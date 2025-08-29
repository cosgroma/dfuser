"""
@brief     
@details   
@author    Mathew Cosgrove
@date      Tuesday December 5th 2023
@file      runtime-man.py
@copyright (c) 2023 NORTHROP GRUMMAN CORPORATION
-----
Last Modified: 01/21/2024 07:35:39
Modified By: Mathew Cosgrove
-----

Device Tree Manager

Usage:
  dt_manager.py info <dts_file> [--output=<ofile>]
  dt_manager.py diff [--output=<ofile>]
  

Options:
  -h --help      Show this screen.
  --output=<ofile>  Specify output JSON file. [default: output.json]
"""
from typing import List, Dict, Any
import os
import json
from datetime import datetime
from docopt import docopt

from pydevicetree import Devicetree, Node

def parse_frequency(freq):
    # Convert hexadecimal frequency string to integer frequency in Hz
    if isinstance(freq, int):
        return int(freq)
    else:
        return int(freq, 16)

def calculate_output_frequency(input_freq, divisors):
    # Apply the divisors to the input frequency to get the output frequency
    output_freq = input_freq
    for div in divisors:
        if div != 0:  # Avoid division by zero
            output_freq //= div  # Assuming integer division for divisors
    return output_freq

def find_node_by_phandle(tree, phandle_ref):
    # Find the node in the tree that corresponds to the given phandle
    for node in tree.child_nodes():
        phandle = node.get_field("phandle")
        if phandle and phandle == phandle_ref:
            return node
    return None

def build_phandle_map(tree):
    # Create a map from phandles to nodes
    phandle_map = {}
    nodes : List[Node] = tree.child_nodes()
    for node in nodes:
        if 'phandle' in node.properties:
            phandle_map[node.properties['phandle'].value[0]] = node
    return phandle_map

def calculate_clock_frequencies(tree):
    # Parse the device tree and build phandle map
    phandle_map = build_phandle_map(tree)
    
    # Define a dictionary to hold the frequencies of the clocks
    clock_frequencies = {}
    nodes : List[Node] = tree.child_nodes()
    # Iterate over each node in the device tree
    for node in nodes:
        
        compatible = node.get_field("compatible")
        if compatible and 'clk' in compatible:
            # This is a clock node, calculate its frequency
            clk_freq = node.get_field("clock-frequency")
            clocks = node.get_fields("clocks")
            div = node.get_fields("div")
            if clk_freq:                
                # Base frequency is directly given
                clock_frequencies[node] = parse_frequency(clk_freq)
            elif clocks and div:
                print(f"{node}: {type(clocks)}, {div}")
                # for clock in clocks:
                #     print(clock)
                # Frequency is derived from another clock and a divisor
                # Assuming the first clock is the input source
                input_phandle = clocks[0]
                input_node = find_node_by_phandle(tree, input_phandle)
                if input_node in clock_frequencies:
                    # Calculate the output frequency
                    input_freq = clock_frequencies[input_node]
                    # output_freq = calculate_output_frequency(input_freq, divisors)
                    # clock_frequencies[node] = output_freq
    
    return clock_frequencies

def process_dts(dts_file):
    # Main execution
    tree = Devicetree.parseFile(dts_file)
    # for node in tree.child_nodes():
    #     print(node)
    # print()
    # print(dir(tree))
    clock_freqs = calculate_clock_frequencies(tree)
    print(clock_freqs)
    return

    # Output the frequency of the APU clock, identified by its node name or compatible string
    apu_clk_node_name = 'acpu_ref_div_clk'  # Replace with the actual node name or compatible string
    apu_clk_node = tree.get_by_path('/soc/clk_ctrl@fd1a0000/' + apu_clk_node_name)
    apu_clk_freq = clock_freqs.get(apu_clk_node, None)

    if apu_clk_freq:
        print(f"The APU clock frequency is: {apu_clk_freq} Hz")
    else:
        print("APU clock frequency could not be determined.")


OTHER_DTBS = [
    "t1tl_cc/ajr/ngc-magnompnt-cc-full.dtb",
    "t1tl_cc/ajr/ngc-magnompnt-cc-l1.dtb",
    "t1tl_cc/ajr/ngc-magnompnt-nrl-cc-updated.dtb",
    "t1tl_cc/justin/Build51_52_53/ngc-magnompnt-nrl-cc-L1.dtb",
    "t1tl_cc/justin/Build51_52_53/ngc-magnompnt-nrl-cc-L1L2L5.dtb",
    "t1tl_cc/justin/ForNick/ngc-magnompnt-nrl-cc-L1L2L5.dtb",
    "t1tl_cc/justin/system_bd_fullbuild/ngc-magnompnt-nrl-cc-L1L2L5.dtb",
    "t1tl_cc/justin/system_bd_L1CA/ngc-magnompnt-nrl-cc-L1.dtb",
    "t1tl_cc/justin/zcu102/L1CA/ad9361-sdr.dtb",
    "t1tl_cc/mat/ngc-magnompnt-nrl-cc-L1L2L5.dtb",
    "t1tl_cc/taylor/ngc-magnompnt-cc-l1.dtb",
    "t1tl_it/boot_files/mpnt/ngc-magnompnt-nrl-cc-L1L2L5.dtb",
    "t1tl_it/boot_files/mpnt/ngc-magnompnt-nrl-rffe2.dtb",
    "t1tl_it/boot_files/mpnt/ngc-magnompnt-old.dtb",
    "t1tl_it/boot_files/mpnt/ngc-magnompnt-smp_0.3.16.dtb",
    "t1tl_it/boot_files/mpnt/ngc-magnompnt-smp_1.0.0.dtb",
    "t1tl_it/boot_files/mpnt/ngc-magnompnt-up_0.3.34.dtb",
    "t1tl_it/boot_files/mpnt/ngc-magnompnt-up_0.3.35.dtb",
    "t1tl_it/boot_files/navdc/innoflight_navdc-rev-0.0.0.1.dtb",
    "t1tl_ss/mpnt_testing/ngc-magnompnt-nrl-cc-L1L2L5.dtb",
]

REF_DTB = "t1tl_cc/justin/system_bd_fullbuild/ngc-magnompnt-nrl-cc-L1L2L5.dtb"
TFTP_BOOT_DIR = "/var/lib/tftpboot"


import fdt

def diff_dtb(ref_dtb, dtb_list):
    out = dict()
    with open(os.path.join(TFTP_BOOT_DIR, ref_dtb), "rb") as f:
        dtb_data = f.read()
    dtb1 = fdt.parse_dtb(dtb_data)
    for t_dtb in dtb_list:
        with open(os.path.join(TFTP_BOOT_DIR, t_dtb), "rb") as f:
            dtb_data = f.read()
        dtb2 = fdt.parse_dtb(dtb_data)
        out[t_dtb] = fdt.diff(dtb1, dtb2)
    return out

from pprint import pprint
def main():
    args = docopt(__doc__)

    output_file = args['--output']
    if args['info']:
        dts_file : str = args['<dts_file>']
        process_dts(dts_file)
    
    if args['diff']:
        out = diff_dtb(REF_DTB, OTHER_DTBS)
        out_dict = dict()
        for k in out:
            if k not in out_dict.keys():
                out_dict[k] = []
            for e in out[k]:
                out_dict[k].append(str(e))
        # out_dict
        pprint(out_dict)

    # if args['convert']
        # if os.path.exists(output_file):
        #     print(f"Error: Output file {output_file} already exists. Use 'update' command to update an existing JSON file.")
        #     return
        # with open(output_file, 'w') as json_file:
        #     json.dump(out, json_file, indent=4)
    

if __name__ == "__main__":
    main()
