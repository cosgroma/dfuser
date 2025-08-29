""" ini_parser.py - A simple INI file parser. 

Usage:
  ini_manager.py update <target_ini> <reference_ini> [--output=<path>] [--diff]
  ini_manager.py join <ini_files>... [--output=<path>]
  ini_manager.py diff <ini_file1> <ini_file2>

Options:
  -h --help         Show this screen.
  --version         Show version.
  --output=<path>   Specify the output file or directory. Defaults to the same location as the target INI.
  --diff            Output the differences between the target and reference INI files.
"""
"""
@brief     
@details   
@author    Mathew Cosgrove
@date      Thursday November 2nd 2023
@file      ini_manager.py
@copyright (c) 2023 NORTHROP GRUMMAN CORPORATION
-----
Last Modified: 11/02/2023 12:55:26
Modified By: Mathew Cosgrove
-----
"""

import typing
import os
import sys
import docopt

from typing import List, Dict, Any

import configparser

def parse_ini_file(file_path: str) -> configparser.ConfigParser:
    config = configparser.ConfigParser()
    config.read(file_path)
    return config

def update_ini(target_config: configparser.ConfigParser, reference_config: configparser.ConfigParser) -> configparser.ConfigParser:
    # Logic to update target_config with reference_config
    target_config.read_dict(reference_config)
    # Return the updated target_config
    
    return target_config

def join_ini_files(ini_files: List[str]) -> configparser.ConfigParser:
    """ Join multiple INI files into a single ConfigParser object.
    
    Args:
        ini_files (List[str]): A list of paths to INI files.
        
    Returns:
        configparser.ConfigParser: A ConfigParser object containing all of the INI files.
    """
    config = configparser.ConfigParser()
    for ini_file in ini_files:
        config.read(ini_file)
    return config
        

def write_ini_file(config: configparser.ConfigParser, file_path: str) -> None:
    """Write a ConfigParser object to a file.
    
    Args:
        config (configparser.ConfigParser): The ConfigParser object to write.
        file_path (str): The path to the file to write to.
        
    Returns:
        None
    """
    with open(file_path, 'w') as configfile:
        config.write(configfile)
        

# Output Differences Function:


def output_differences(target_config: configparser.ConfigParser, reference_config: configparser.ConfigParser) -> None:
    """Output the differences between two ConfigParser objects.
    
    Args:
        target_config (configparser.ConfigParser): The target ConfigParser object.
        reference_config (configparser.ConfigParser): The reference ConfigParser object.
        
    Returns:
        None
    """
    differences = compare_configs(target_config, reference_config)
    print(f'Sections Added: {differences["sections_added"]}')
    print(f'Sections Removed: {differences["sections_removed"]}')
    print(f'Keys Added: {differences["keys_added"]}')
    print(f'Keys Removed: {differences["keys_removed"]}')
    print(f'Changed Values: {differences["changed_values"]}')
    

# can compare two configparser objects and output the differences. Here's a high-level outline of what that function might look like:
def compare_configs(config1: configparser.ConfigParser, config2: configparser.ConfigParser) -> Dict[str, Any]:
    # Initialize a structure to hold the differences
    differences = {
        'sections_added': [],
        'sections_removed': [],
        'keys_added': {},
        'keys_removed': {},
        'changed_values': {}
    }

    # Compare sections
    config1_sections = set(config1.sections())
    config2_sections = set(config2.sections())
    differences['sections_added'] = config2_sections - config1_sections
    differences['sections_removed'] = config1_sections - config2_sections
    
    # Compare keys and values within each section
    for section in config1_sections.intersection(config2_sections):
        config1_keys = set(config1[section].keys())
        config2_keys = set(config2[section].keys())
        differences['keys_added'][section] = config2_keys - config1_keys
        differences['keys_removed'][section] = config1_keys - config2_keys
        for key in config1_keys.intersection(config2_keys):
            if config1[section][key] != config2[section][key]:
                differences['changed_values'].setdefault(section, []).append(key)

    # Return the differences
    return differences

# Command-Line Interface:
# The docopt arguments will be parsed and used to determine which core function to call and with what parameters.

# Implementation of the --diff Option
# For the --diff option, we need a function that 

def update_command(arguments: Dict[str, Any]) -> None:
    """Run the update command.
    
    Args:
        arguments (Dict[str, Any]): The parsed arguments from docopt.
        
    Returns:
        None
    """
    # Check if the ini files exist
    if not os.path.exists(arguments['<target_ini>']):
        raise FileNotFoundError(f'Could not find target INI file: {arguments["<target_ini>"]}')
    
    if not os.path.exists(arguments['<reference_ini>']):
        raise FileNotFoundError(f'Could not find reference INI file: {arguments["<reference_ini>"]}')
    
    target_config = parse_ini_file(arguments['<target_ini>'])
    reference_config = parse_ini_file(arguments['<reference_ini>'])
    
    updated_config = update_ini(target_config, reference_config)
    
    if arguments['--output']:
        write_ini_file(updated_config, arguments['--output'])
    else:
        write_ini_file(updated_config, arguments['<target_ini>'])

def join_command(arguments: Dict[str, Any]) -> None:
    """Run the join command.
    
    Args:
        arguments (Dict[str, Any]): The parsed arguments from docopt.
        
    Returns:
        None
    """
    # Check if the ini files exist
    for ini_file in arguments['<ini_files>']:
        if not os.path.exists(ini_file):
            raise FileNotFoundError(f'Could not find INI file: {ini_file}')
    
    config = join_ini_files(arguments['<ini_files>'])
    
    if arguments['--output']:
        write_ini_file(config, arguments['--output'])
    else:
        raise NotImplementedError('The --output option is required for the join command.')

def diff_command(arguments: Dict[str, Any]) -> None:
    """Run the diff command.
    
    Args:
        arguments (Dict[str, Any]): The parsed arguments from docopt.
        
    Returns:
        None
    """
    # Check if the ini files exist
    if not os.path.exists(arguments['<ini_file1>']):
        raise FileNotFoundError(f'Could not find INI file: {arguments["<ini_file1>"]}')
    
    if not os.path.exists(arguments['<ini_file2>']):
        raise FileNotFoundError(f'Could not find INI file: {arguments["<ini_file2>"]}')
    
    config1 = parse_ini_file(arguments['<ini_file1>'])
    config2 = parse_ini_file(arguments['<ini_file2>'])
    
    output_differences(config1, config2)

command_table = {
    'update': update_command,
    'join': join_command,
    'diff': diff_command
}

def main():
    arguments = docopt.docopt(__doc__, version='ini_parser.py 0.1')
    
    # Call the appropriate command
    for command, function in command_table.items():
        if arguments[command]:
            try:
                function(arguments)
                break
            except Exception as e:
                print(f'Error running command: {e}')
                break

if __name__ == '__main__':
    main()
