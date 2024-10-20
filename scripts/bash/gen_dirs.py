#! /usr/bin/env python3

import json
import os
import sys

def process(entries):
    for entry in entries:
        if entry["type"] == "directory":
            os.makedirs(entry["name"], exist_ok=True) # Thanks @pLumot
            os.chdir(entry["name"])
            process(entry.get("contents", []))
            os.chdir('..')
        if entry["type"] == "file":
            with open(entry["name"], "w"): pass
        if entry["type"] == "link":
            os.symlink(entry["name"], entry["target"])

# read standard input
structure = json.load(sys.stdin)
process(structure)