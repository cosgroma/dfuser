"""
@brief     
@details   
@author    Mathew Cosgrove
@date      Thursday January 4th 2024
@file      test_regex.py
@copyright (c) 2024 NORTHROP GRUMMAN CORPORATION
-----
Last Modified: 01/04/2024 02:56:39
Modified By: Mathew Cosgrove
-----
"""

import re

# Sample objdump line
line = "1d2a4:       e28d002c        add     r0, sp, #44     ; 0x2c"

# Regex pattern
pattern = re.compile(r'([0-9a-f]+):\s+([0-9a-f]+)\s+(\w+)\s+([^;]+)(?:\s+;.*)?')

# Search for the pattern
match = pattern.search(line)
if match:
    address = match.group(1)
    opcode = match.group(2)
    mnemonic = match.group(3)
    operands = match.group(4).strip()  # Trim any trailing whitespace

    print(f"Address: {address}, Opcode: {opcode}, Mnemonic: {mnemonic}, Operands: {operands}")
else:
    print("No match found.")