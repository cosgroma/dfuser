# Running a Design

# Options
# 'p': config.prn
# 'm': config.trans_matrix (classic : 0, m : 1, m-acq: 2, c-exam: 3)
# 't': config.code_type (CaCode = 0 MCode PseudoM YCode)
# 'c': config.chip_spacing
# 'i': config.pdi
# 'd': config.doppler_center
# 's': config.doppler_span
# 'f': config.carrier_freq
# 'r': config.samp_rate
# 'z': config.num_children
# 'n': num_channels
# 'x': config.stream_indx
# sdr new -m 0 -p 17 -t 0 -d 3300 -f 2.0e6 -r 8.0e6 -z 0 -n 1 -x 0
# sdr new -m 0 -p 13 -t 0 -n 1
#sdr new -m 0 -t 0 -n 1 -p 5
#sdr new -m 0 -t 0 -n 1 -p 18
#sdr new -m 0 -t 0 -n 1 -p 20
#sdr new -m 0 -t 0 -n 1 -p 25
#sdr new -m 0 -t 0 -n 1 -p 29
#sdr new -m 0 -t 0 -n 6
sdr new -m 0 -t 0 -n 4