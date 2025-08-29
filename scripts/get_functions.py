#!/usr/bin/env python
"""get_functions.py

Usage:
    get_functions.py <root_dir> -o <output_file>
    get_functions.py [-h | --help]
    
Arguments:
    -h --help   Show this screen.
    root_dir    Root directory to search for C/C++ files
    -o          Output file to store the functions information

Examples:
    python get_functions.py /home/user/project
"""
import os
import re
import json
import sys
import docopt

from pycparser import parse_file, c_ast

# def extract_functions_from_file(file_path):
#     try:
#         ast = parse_file(file_path, use_cpp=False)
#     except:
#         return []

#     functions = []

#     # Visitor pattern to traverse the AST
#     class FuncDefVisitor(c_ast.NodeVisitor):
#         def visit_FuncDef(self, node):
#             return_type = node.decl.type.type.names[0] if isinstance(node.decl.type.type, c_ast.IdentifierType) else None
#             func_name = node.decl.name
#             args = [param.name for param in node.decl.type.args.params] if node.decl.type.args else []
#             functions.append({
#                 'name': func_name,
#                 'return_type': return_type,
#                 'arguments': args
#             })

#     v = FuncDefVisitor()
#     v.visit(ast)
#     return functions

def extract_functions_from_file(file_path):
    functions = []
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
        # Regular expression to match C/C++ function prototypes declarations
        pattern = re.compile(r'(\w+\s+)?(\w+\s+)(\w+)\s*\(([^)]*)\)')
        
        # pattern = re.compile(r'(\w+\s+)?(\w+\s+)(\w+)\s*\(([^)]*)\)(?!\s*if|for)')
        # return_type, _, func_name, args = match.groups()
        # pattern = re.compile(r'((?:\w+\s+)?\w+)\s+(\w+)\s*\((.*)\)\s*{')
        # return_type, func_name, args = match.groups()
        # pattern = re.compile(r'(\w+\s+)?(\w+\s+)(\w+)\s*\(([^)]*)\)')
        for match in pattern.finditer(content):
            
            functions.append({
                'name': func_name,
                'return_type': return_type.strip() if return_type else None,
                'arguments': [arg.strip() for arg in args.split(',')]
            })
    return functions

def main():
    # parse command line arguments using docopt
    args = docopt.docopt(__doc__)
    functions_info = {}
    
    root_dir = args['<root_dir>']
    if not os.path.isdir(root_dir):
        print('Error: Invalid root directory')
        sys.exit(1)
    
    output_file = args['<output_file>']
    
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(('.h', '.c', '.cpp')):
                file_path = os.path.join(dirpath, filename)
                functions = extract_functions_from_file(file_path)
                if functions:
                    functions_info[file_path] = functions

    with open(output_file, 'w') as f:
        json.dump(functions_info, f, indent=4)

if __name__ == '__main__':
    main()