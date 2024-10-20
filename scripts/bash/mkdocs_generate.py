"""
@brief     
@details   
@author    Mathew Cosgrove
@date      Friday December 15th 2023
@file      mkdocs_generate.py
@copyright (c) 2023 NORTHROP GRUMMAN CORPORATION
-----
Last Modified: 12/15/2023 06:54:47
Modified By: Mathew Cosgrove
-----

This script generates Markdown files for all pages in a mkdocs YAML file.

Usage:
    mkdocs_generate.py <yaml_path>
    mkdocs_generate.py -f <yaml_path>
    
Options:
    -h --help     Show this screen.
    --version     Show version.
    -f --force    Force overwrite of existing files.
"""

from typing import Dict
import docopt
import os
import yaml


def create_markdown_files(yaml_path, overwrite=False):
    """
    Reads the mkdocs YAML file and creates Markdown files based on the navigation structure.

    Args:
    yaml_path (str): The path to the mkdocs YAML file.
    overwrite (bool): Whether to overwrite existing files.
    """
    with open(yaml_path, 'r') as file:
        mkdocs_config = yaml.safe_load(file)

    base_path = os.path.dirname(yaml_path)

    # check for docs directory at base path
    if not os.path.exists(os.path.join(base_path, 'docs')):
        os.makedirs(os.path.join(base_path, 'docs'), exist_ok=True)
        print(f"Created directory: {os.path.join(base_path, 'docs')}")
    base_path = os.path.join(base_path, 'docs')
    
    relative_links_dict = {}
    for section in mkdocs_config.get('nav', []):
        for subsection, file_path in section.items():
            relative_links_dict[subsection] = file_path
            if isinstance(file_path, str):
                # Single file in section
                check_and_create_file(os.path.join(base_path, file_path), overwrite=overwrite)
            elif isinstance(file_path, list):
                # Multiple files in subsection
                for item in file_path:
                    for title, path in item.items():
                        check_and_create_file(os.path.join(base_path, path), overwrite=overwrite)

# def add_releative_links_to_index(file_path, relative_links_dict: Dict[str, str]):
#     """
#     Adds relative links to an index file.

#     Args:
#     file_path (str): The path to the Markdown file.
#     relative_links_dict (Dict[str, str]): A dictionary of relative links.
#     """
#     with open(file_path, 'r+') as file:
#         content = file.read()
#         file.seek(0, 0)
#         for title, link in relative_links_dict.items():
#             file.write(f'- [{title}]({link})\n')
#         file.write('\n')
#         file.write(content)
        
def add_metadata_header_to_file(file_path, metadata: Dict[str, str]):
    """
    Adds a metadata header to a Markdown file.

    Args:
    file_path (str): The path to the Markdown file.
    title (str): The title of the Markdown file.
    """
    with open(file_path, 'r+') as file:
        content = file.read()
        file.seek(0, 0)
        file.write('---\n')
        for key, value in metadata.items():
            file.write(f'{key}: {value}\n')
        file.write('---\n\n')
        file.write(content)

def update_metadata_header_in_file(file_path, metadata: Dict[str, str]):
    """
    Updates a metadata header in a Markdown file.

    Args:
    file_path (str): The path to the Markdown file.
    title (str): The title of the Markdown file.
    """
    with open(file_path, 'r+') as file:
        content = file.read()
        # check for existing metadata header
        if content.startswith('---'):
            # extract existing metadata header
            metadata_header = content[3:content.find('---', 3)]   
            content = content[content.find('---', 3) + 3:]
            # compare existing metadata header to new metadata
            # for key, value in metadata.items():
            #     if f'{key}: {value}' not in metadata_header:
            #         metadata_header += f'{key}: {value}\n'
                    
        # write new metadata header
        file.seek(0, 0)
        file.write('---\n')
        for key, value in metadata.items():
            file.write(f'{key}: {value}\n')
        file.write('---\n\n')
        file.write(content)

def unslugify(slug):
    """
    Converts a slug to a title.

    Args:
    slug (str): The slug to convert.
    """
    return ' '.join([word.capitalize() for word in slug.split('-')])

def check_and_create_file(file_path, overwrite=False):
    """
    Checks if a Markdown file exists, and if not, creates it.

    Args:
    file_path (str): The path to the Markdown file.
    """
    if overwrite or not os.path.exists(file_path):
        if overwrite:
            print(f"Overwriting file: {file_path}")
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        with open(file_path, 'w') as file:
            # if index file, add title
            file.write(
                f"# {unslugify(os.path.basename(file_path).replace('.md', ''))}\n\n")
            print(f"Created file: {file_path}")
        metadata = {
            'title': os.path.basename(file_path).replace('.md', ''),
            'date': '2023-12-15T05:28:55-05:00',
            'lastmod': '2023-12-15T05:28:55-05:00',
            'draft': 'false',
            'tags': f'[]',
            'categories': '[]',
            'slug': os.path.basename(file_path).replace('.md', ''),
            'author': 'Mathew Cosgrove',
            'summary': '',
        }
        add_metadata_header_to_file(file_path, metadata)
        print(f"Added metadata to file: {file_path}")
    else:
        print(f"File already exists: {file_path}")

# # Example usage
# create_markdown_files('path/to/your/mkdocs.yml')


def main():
    """
    Main entry point for the script.
    """
    arguments = docopt.docopt(__doc__, version='mkdocs_generate 0.1.0')
    create_markdown_files(arguments['<yaml_path>'], overwrite=arguments['--force'])


if __name__ == '__main__':
    main()
