#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Usage: split_data_model.py [-hvnd] <input_file> <output_dir>
          split_data_model.py (-h | --help)
          split_data_model.py --version
          split_data_model.py [-vd] (-n | --dry-run) <input_file> <output_dir>
          split_data_model.py (-n | --dry-run) <input_file> <output_dir>

Options:
    -h --help     Show this screen.
    --version     Show version.
    -v --verbose  Show verbose output.
    -n --dry-run  Don't write any files, just show what would be written.
    -d --debug    Show debug output.

Arguments:
    <input_file>  The file containing the data model.
    <output_dir>  The directory to write the split data model to.

"""
import logging
import docopt
import prettyprinter as pp
import os
import re
from typing import Dict, List

pp.install_extras(["dataclasses"])


def get_datamodel_from_models_content(models_content: str) -> Dict[str, str]:
    """Get the data model from the content of a models.py file.

    Args:
        models_content (str):  The content of a models.py file.

    Returns:
        Dict[str, str]:  A dictionary with the entity name as key and the class definition as value.
    """
    datamodel = {}

    for class_def in re.findall(r"(class\s+\w+\(.*?\):(?:\n\s+.+?)+)", models_content, re.MULTILINE | re.DOTALL):
        # 1. r"(class\s+\w+\(.*?\):(?:\n\s+.+?)+)"
        # 2. class\s+\w+\(.*?\) - find a class definition
        # 3. (?:\n\s+.+?)+ - find 1 or more lines with at least one space/tab at the beginning
        # 4. \n\s+ - find a new line followed by at least one space/tab
        # 5. .+? - find any character at least once, but in a non-greedy way
        # 6. + - match the previous expression 1 or more times
        entity_name = re.search(r"class\s+(\w+)\(", class_def).group(1)
        # 1. r is used to raw string, which means \s is not a special character
        # 2. class is the keyword in python
        # 3. \s means space
        # 4. + means one or more
        # 5. \w is a word character
        # 6. ( means start capturing
        # 7. (\w+) means capture one or more word characters
        # 8. ) means end capturing
        # 9. \s is space
        # 10. \( is (
        datamodel[entity_name] = class_def

    return datamodel


def write_model_files(datamodel: Dict, output_dir: str, dry_run: bool = False):
    """Write the data model to separate files.

    Args:
        datamodel (Dict):  The data model to write to files.
        output_dir (str):  The directory to write the files to.
        dry_run (bool, optional):  If True, don't write any files, just show what would be written. Defaults to False.
    """
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Add an __init__.py file in the output directory
    with open(os.path.join(output_dir, "__init__.py"), "w") as f:
        pass

    # Split classes into separate files
    for entity_name, class_def in datamodel.items():
        output_file = os.path.join(output_dir, f"{entity_name.lower()}.py")
        print(class_def)

        if dry_run:
            print(f"Would write {output_file} with content:\n{class_def}")
            continue
        with open(output_file, "w") as f:
            f.write(class_def)


def split_models_file(input_file: str, output_dir: str, dry_run: bool = False):
    """Split the data model in a models.py file into separate files.

    Args:
        input_file (str):  The file containing the data model.
        output_dir (str):  The directory to write the split data model to.
        dry_run (bool, optional): . Defaults to False.
    """

    # check if the input file exists and models.py is in the file name
    if not os.path.exists(input_file) or "models.py" not in input_file:
        logging.error(
            f"Input file {input_file} does not exist or is not named models.py")
        return

    with open(input_file, "r") as f:
        content = f.read()

    datamodel = get_datamodel_from_models_content(content)

    logging.debug("Data model:")
    logging.debug(pp.pformat(datamodel))
    logging.info("Splitting data model into separate files")

    write_model_files(datamodel, output_dir, dry_run=dry_run)


def main():
    """Parse arguments using doc opt and call the split_models_file function.
    """
    args = docopt.docopt(__doc__, version="0.0.1")
    # sets up logging
    if args["--verbose"]:
        logging.basicConfig(level=logging.INFO)
    elif args["--debug"]:
        logging.basicConfig(level=logging.DEBUG)

    split_models_file(args["<input_file>"],
                      args["<output_dir>"], dry_run=args["--dry-run"])


if __name__ == "__main__":
    main()
