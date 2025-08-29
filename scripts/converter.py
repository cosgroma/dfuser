''' convert.py
This script converts a large binary file of ADC samples to a baseband signal.


'''

import numpy as np
import struct
from scipy.signal import resample, butter, lfilter

from scipy.signal import welch
import matplotlib.pyplot as plt

T = 1e-3

def encode_sample_to_3bit(sample):
    # Assuming the sample is in the range -1.0 to 1.0, scale it to 0-7 (3 bits)
    # and clamp to ensure it fits in 3 bits.
    # The range -1.0 to 1.0 is assumed to be linearly mapped to 0 to 7.
    encoded = int((sample - 1)/2)  # 3.5 scales and biases the value
    
    encoded = max(min(encoded, 7), 0)  # clamp between 0 and 7
    return encoded

def build_64bit_value(samples, num_channels=1, spare_bits=10):
    """
    Construct a 64-bit value from a set of complex samples.

    Parameters:
    samples (list): A list of lists, where each sublist contains complex samples for one channel.
    spare_bits (int): Number of spare bits in the 64-bit word.

    Returns:
    int: The 64-bit value constructed from the complex samples.
    """

    # Ensure we have the correct number of samples
    # assert len(samples) == 3 and all(len(channel) == 3 for channel in samples)

    # Initialize the 64-bit value
    value = 0
    # samples = (samples - 1)/2
    if num_channels == 1:
        # We have 3 channels, each with 3 samples, and each sample is complex (I and Q)
        for sample in samples:
            # Encode the real and imaginary parts to 3-bit values
            i_part = encode_sample_to_3bit(sample.real)
            q_part = encode_sample_to_3bit(sample.imag)

            # Shift the encoded parts into their position in the 64-bit value
            value <<= 6  # Make room for 6 bits (3 bits I, 3 bits Q)
            value |= (i_part << 3) | q_part  # Add the I and Q parts
                
    if num_channels == 3:
        # We have 3 channels, each with 3 samples, and each sample is complex (I and Q)
        for channel in samples:
            for sample in channel:
                # Encode the real and imaginary parts to 3-bit values
                i_part = encode_sample_to_3bit(sample.real)
                q_part = encode_sample_to_3bit(sample.imag)

                # Shift the encoded parts into their position in the 64-bit value
                value <<= 6  # Make room for 6 bits (3 bits I, 3 bits Q)
                value |= (i_part << 3) | q_part  # Add the I and Q parts

    # Shift the entire value to leave space for spare bits at the LSB end
    value <<= spare_bits

    return value





class SignalProcessor:
    def __init__(self, input_path, output_path, if_freq, orig_sr, target_sr, block_size):

        self.block_size = block_size  # Number of samples per chunk
        self.lp_cutoff_freq = min(if_freq, orig_sr / 2)  # Low-pass filter cutoff frequency
        self.num_channels = 4
        self.psds = []
        self.setup_input_config(input_path, if_freq, orig_sr)
        self.setup_output_config(output_path, target_sr)
    
    def setup_input_config(self, input_path, if_freq, orig_sr):
        
        self.input_path = input_path
        self.if_freq = if_freq
        self.orig_sr = orig_sr
    
    def setup_output_config(self, output_path, target_sr):
        self.samples_per_64bit_word = 10
        self.num_output_channels = 1
        self.output_quantization_bits = 3
        self.target_sr = target_sr
        self.output_path = output_path
        self.outfile = open(self.output_path, 'wb')
        
    def low_pass_filter(self, signal):
        nyquist = 0.5 * self.orig_sr
        normal_cutoff = self.lp_cutoff_freq / nyquist
        b, a = butter(5, normal_cutoff, btype='low', analog=False)
        return lfilter(b, a, signal)

    def downconvert_to_baseband(self, chunk):
        t = np.arange(len(chunk)) / self.orig_sr
        complex_exponential = np.exp(-1j * 2 * np.pi * self.if_freq * t)
        mixed_signal = chunk * complex_exponential
        baseband_signal = self.low_pass_filter(mixed_signal)
        return baseband_signal

    def calculate_psd(self, channel_data):
        """
        Calculates the Power Spectral Density (PSD) for each channel.

        :param channel_data: a numpy array of channel data.
        :param sample_rate: Sample rate in Hz.
        :param dwell_time: Dwell time for the PSD calculation.
        :return: A list of PSDs for each channel.
        """

        # Calculate the PSD for each channel
        # fft_channel_data = np.fft.fft(channel_data)
        # # conjugate of the second half of the fft
        # # fft_channel_data_conj = np.conjugate(fft_channel_data[1:int(len(fft_channel_data) / 2)])
        # frequency = np.fft.fftfreq(len(fft_channel_data), 1 / self.orig_sr)
        # power = np.abs(fft_channel_data) ** 2
        frequency, power = welch(channel_data, fs=self.target_sr, nperseg=1024, noverlap=512, nfft=1024)
        return (frequency, power)
    
    def plot_psd(self, psds):
        """
        Plots the Power Spectral Density for each channel.

        :param psds: A list of PSDs for each channel.
        """
        for i, (frequency, power) in enumerate(psds):
            plt.figure()
            plt.semilogy(frequency, power, '.')
            plt.title(f'Channel {i+1} Power Spectral Density')
            plt.xlabel('Frequency (Hz)')
            plt.ylabel('Power/Frequency (dB/Hz)')
            plt.grid(True)
        plt.show()
    
    def calculate_baseband_length(self, desired_length):
        # Calculate the ratio of the original to target sample rate
        ratio = self.orig_sr / self.target_sr
        # Calculate the number of samples in baseband_data that, when upsampled,
        # will result in an integer multiple of 3
        baseband_length = np.ceil((desired_length / ratio) / self.samples_per_64bit_word) * self.samples_per_64bit_word
        # Ensure it's an integer
        return int(baseband_length)


    def get_num_64bit_words_per_ms(self):
        # self.num_channels
        # self.orig_sr
        # self.samples_per_64bit_word
        dt_per_word = self.samples_per_64bit_word / self.orig_sr
        
        return int(np.floor(T / dt_per_word))
        
    def process_blocks(self, block_num_max=-1):
        
        # Example usage:
        desired_length = int((self.target_sr * T)/self.samples_per_64bit_word)
        samples_to_read = self.calculate_baseband_length(desired_length)
        output_len = int(samples_to_read * self.target_sr / self.orig_sr)
        output_len_update = np.ceil((output_len) / self.samples_per_64bit_word) * self.samples_per_64bit_word
        samples_to_read_update = int(output_len_update * self.orig_sr / self.target_sr)
        samples_to_read = samples_to_read_update
        
        # samples_to_read = self.get_num_64bit_words_per_ms()
        with open(self.input_path, 'rb') as infile:
            block_num = 0
            # get length of file
            infile.seek(0, 2)
            file_size = infile.tell()
            infile.seek(0, 0)
            block_num_max = int(file_size / (self.num_channels * samples_to_read))
            while True:
                # print percent complete
                if block_num % 1000 == 0:
                    print(f'{block_num/block_num_max*100:.1f}% complete', end='\r')
                # Read a chunk of the file
                chunk = np.fromfile(infile, dtype=np.int8, count=self.num_channels*samples_to_read)
                if chunk.size == 0:
                    break  # End of file
                
                reshaped_data = chunk.reshape((samples_to_read, self.num_channels))
                channel_data_array = reshaped_data.transpose()
                channel_data = channel_data_array[0]
                baseband_data = self.downconvert_to_baseband(channel_data)

                # Upsample the baseband signal
                upsampled_block = resample(baseband_data, int(np.ceil(len(baseband_data) * self.target_sr / self.orig_sr)))
                # Rescale upsampled_block to be between  -1.0, 1.0
                upsampled_block = upsampled_block / np.max(np.abs(upsampled_block))
                # samples_out.extend(upsampled_block)
                self.write_block_to_file(upsampled_block)
                block_num += 1
                
                if block_num == block_num_max:
                    break
        self.outfile.close()
        
    def write_block_to_file(self, samples):
        """
        Writes a list of samples to a file.

        :param samples: A list of samples to write to the file.
        :param output_file_path: The path to the output file.
        """

        for idx in range(int(len(samples)/self.samples_per_64bit_word)):
            # slice the samples into sublists of length samples_per_64bit_word
            sample_slice = samples[idx*self.samples_per_64bit_word:(idx+1)*self.samples_per_64bit_word]
            # Convert the sample to a 64-bit value
            value = build_64bit_value(sample_slice, num_channels=1, spare_bits=4)
            self.outfile.write(struct.pack('>Q', value))



# # To write this to a file, you would use struct to pack it into binary format
# with open('output.bin', 'wb') as f:
#     f.write(struct.pack('<Q', value_64bit))
        
input_file_path = '/media/sas1/data/mcode_8bit_4chan.bin'
output_file_base_path = '/media/sas1/data/mcode_8bit_4chan.LS3W'
if_freq = 13.68e6  # Intermediate frequency
original_sample_rate = 56.32e6  # Original sample rate
target_sample_rate = 58e6  # Target sample rate
samples_per_64bit_word = 10

num_channels = 4
block_size = int(original_sample_rate * T)  # Number of samples per block

processor = SignalProcessor(input_file_path, output_file_base_path, if_freq, original_sample_rate, target_sample_rate, block_size)
samples_out = processor.process_blocks()