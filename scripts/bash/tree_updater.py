# This script uses docopt for options parsing
# This script uses the HOME directory of the user to store the directory tree that was built
# This script takes an argument to the directory to build the tree from
# This script walks the directory tree and builds a list of files and directories, it captures the file size and the md5sum of the file
""" tree_updater.py

Usage:
    tree_updater.py -h | --help
    tree_updater.py --version
    tree_updater.py create <directory> [--force] [--verbose] [--debug] [--dry-run] [-o <output_file>]
    tree_updater.py show

Options:
    -h --help       Show this screen.
    --version       Show version.

Arguments:
    <directory>     The directory to build the tree from
"""

from typing import List, Dict, Any
from datetime import datetime
from docopt import docopt

import docopt
import hashlib
import json
import mimetypes
import os
import sys
import logging

logging.basicConfig(filename='myapp.log', level=logging.INFO)
logger = logging.getLogger(__name__)

type_map = {
    "application/x-executable": "Executable",
    "text/plain": "Text",
    "text/html": "HTML",
    "text/css": "CSS",
    "text/javascript": "JavaScript",
    "application/json": "JSON",
    "application/pdf": "PDF",
    "image/jpeg": "JPEG"
}

PIPE = "│"
ELBOW = "└──"
TEE = "├──"
PIPE_PREFIX = "│   "
SPACE_PREFIX = "    "

class FileNode:
    def __init__(self, name, full_path, file_type, file_size, md5sum):
        self.name = name
        self.full_path = full_path
        self.file_type = file_type
        self.file_size = file_size
        self.md5sum = md5sum
        self.total_size = 0
        
        self.children : List[FileNode] = []

    def add_child(self, child_node):
        self.children.append(child_node)

    def get_total_size(self):
        total_size = self.file_size
        for child in self.children:
            total_size += child.get_total_size()
        self.total_size = total_size
        return total_size

    def to_dict(self):
        return {
            "name": self.name,
            "file_type": self.file_type,
            "file_size": self.file_size,
            "md5sum": self.md5sum,
            "total_size": self.total_size,
            "children": [child.to_dict() for child in self.children]
        }

def setup_user_config() -> str:
    """
    This function sets up the user config directory and returns the path to the config directory
    """
    home_dir = os.path.expanduser("~")
    print(f"Home directory: {home_dir}")
    config_dir = os.path.join(home_dir, ".tree_updater")
    if not os.path.exists(config_dir):
        os.mkdir(config_dir)
    return config_dir

def create_new_tree_file(config_dir: str, directory:str) -> str:
    """
    This function creates a new tree file and returns the path to the tree file
    """
    if sys.platform == "win32":
        directory = directory.replace(":", "_")
    tree_file = os.path.join(config_dir, directory.replace(os.sep, "_") + ".tree")
    if os.path.exists(tree_file):
        print(f"Tree file already exists: {tree_file}")
        sys.exit(1)
    return tree_file

def get_file_info_dict(file:str) -> Dict[str, Any]:
    """
    This function takes a file path and returns the file size and md5sum
    """
    pass

def get_node(file_path:str) -> FileNode:
    """
    This function takes a file path and returns a FileNode object
    """
    file_size = os.path.getsize(file_path)
    file = os.path.basename(file_path)
    if os.path.isdir(file_path):
        file_type = "dir"
        md5sum = ""
        dir_node = FileNode(file, file_path, file_type, file_size, md5sum)
        file_node = build_tree_recursive(dir_node, file_path)        
    else:
        file_type = "file"
        md5sum = hashlib.md5(open(file_path, "rb").read()).hexdigest()
        file_node = FileNode(file, file_path, file_type, file_size, md5sum)
    return file_node

def build_tree_recursive(root_node, directory:str) -> FileNode:
    """
    This function takes a directory path and returns a FileNode object
    """
    # get all the files and directories in the directory
    for file in os.listdir(directory):
        file_path = os.path.join(directory, file)
        file_node = get_node(file_path)
        root_node.add_child(file_node)
    return root_node

def main():
    """
    This is the main function
    """
    # Parse the arguments
    args = docopt.docopt(__doc__)
    print(args)
    

    # Get the config directory
    config_dir = setup_user_config()
    
    # print(tree_file)
    root_path = args["<directory>"]
    root_name = os.path.basename(root_path)
    # Create a new tree file
    tree_file = create_new_tree_file(config_dir, root_path)
    root_node = FileNode(root_name, root_path, "dir", "", "")
    # Get the tree dictionary
    root_node = build_tree_recursive(root_node, root_path)
    # print(str(root_node))
    # Write the tree dictionary to the tree file
    with open(tree_file, "w") as f:
        json.dump(root_node.to_dict(), f, indent=4)
        # f.write(str(root_node))

if __name__ == "__main__":
    main()