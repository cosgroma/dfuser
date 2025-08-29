#!/bin/bash

component_list=(cc sm pp)
built_components=()

for component in ${component_list[@]}; do
    # echo "component: $component"
    # Get component directory
    component_dir=$(find comp/ -maxdepth 1 -type d -name "$component")
    # echo "component_dir: $component_dir"
done;

function get_build_products(){
    filelist=$(cat build/*.log | grep output | cut -d':' -f2- | sed 's/^[ \t]*//;s/[ \t]*$//')

    # array of built components    
    for f in ${filelist[@]}; do 
        built_component=$(basename $f)
        # built_component=${built_component%.out}
        built_components+=($built_component)
    done;
    ## built_components
    # - cc-0.2.1-4.out
    # - pvtprovider-0.3.1-4.out
    # - sm-0.3.4-5.out
}

# Runtime Script
RUNTIME_SCRIPT="runtime/helix/etc/tsdr-comp.csh"

## Runtime Script Contents

# sdr_priority_bias = 13
# user_ip = "192.168.2.153"
# prog_logic_config = "host:/etc/vpx581/test.ini"
# sdr_config_file = "host:/etc/sdr/sdr.ini"
# sdr_cmd_file = "host:/etc/sdr/sdr.cacode-static.conf"
# # sdr_cmd_file = "host:/etc/sdr/sdr.cacode-static-small.conf"
# # sdr_cmd_file = "host:/etc/sdr/sdr.cacode.conf"

# sample_rate = "5.0e6"
# carrier_freq = "1.270002e6"
# rxlo_offset = 1270000
# lo_freq = "1575.42e6"
# band_width = "18.e6"
# DATA_SEL_DDS = 0
# DATA_SEL_DMA = 2

# sdr_cmd_pipe = "/sdrcmdq"

# ld < host:/dkm/host-0.2.1.out
# ld < host:/dkm/ad9361fmc-0.5.out
# ld < host:/armarch7/bin/cc-0.2.1-2.out
# ld < host:/armarch7/bin/cc-0.2.1-2.out

# # Parse RUNTIME_SCRIPT to find all ld <
# runtime_script_lds=$(grep "^ld <" $RUNTIME_SCRIPT)
# echo "runtime_script_lds: $runtime_script_lds"

# # Parse RUNTIME_SCRIPT to find all ld < host:/dkm/<component>-<version>.out
# runtime_script_lds_dkm=$(grep "^ld < host:/dkm/" $RUNTIME_SCRIPT)
# echo "runtime_script_lds_dkm: $runtime_script_lds_dkm"

# Parse RUNTIME_SCRIPT to find all ld < host:/armarch7/bin/<component>-<version>.out
runtime_script_lds_armarch7=$(grep "^ld < host:/armarch7/bin/" $RUNTIME_SCRIPT)
echo "runtime_script_lds_armarch7: $runtime_script_lds_armarch7"
get_build_products
for bc in ${built_components[@]}; do
    echo $bc;
done;

# component_list=(cc sm pp)
# Find in $runtime_script_lds_armarch7 if it contains any of the components in $component_list
# for component in ${component_list[@]}; do
#     echo "component: $component"
#     # Get component directory
#     if [[ $runtime_script_lds_armarch7 == *"$component_build_product"* ]]; then
#         echo "runtime script contains $component_build_product"
#     else
#         echo "runtime script does not contain $component_build_product"
#     fi
# done;

