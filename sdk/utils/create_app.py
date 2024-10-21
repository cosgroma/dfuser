"""
Usage:
    create_app.py -f <filename> -o <output_directory>

Options:
    -h --help                   Show this screen.
    -f <filename>               JSON file that describes the app structure.
    -o <output_directory>       Name of the output directory to create.
"""

from datetime import datetime
from typing import Dict
import os
import json
from docopt import docopt


DOCUMENTATION_TEMPLATE = """
\"\"\"
{description}

Usage:
{usage}

Examples:
{examples}

Author: {author}
Last edited: {last_edited}
License: {license}

Version: {version}
Dependencies: {dependencies}
\"\"\"
"""


def apply_python_template(template_dict: Dict[str, str]) -> str:
    """
    Applies the Python template to the string.
    """
    return DOCUMENTATION_TEMPLATE.format(**template_dict)


def create_file(mvc_component: Dict, output_directory: str) -> bool:
    """
    Creates the file for the MVC component.
    """
    mvc_component_doc_template = {
        "file_name": mvc_component.get("file_name", "") + ".py",
        "description": mvc_component.get("description", ""),
        "author": mvc_component.get("author", ""),
        "last_edited": f"{datetime.now():%Y-%m-%d}",
        "usage": mvc_component.get("usage", ""),
        "examples": mvc_component.get("examples", ""),
        "license": mvc_component.get("license", ""),
        "version": mvc_component.get("version", ""),
        "dependencies": mvc_component.get("dependencies", ""),
    }
    mvc_component_doc = apply_python_template(mvc_component_doc_template)
    mvc_component_name = f"{mvc_component.get('file_name','')}.py"
    # Only create the file if it doesn't already exist.
    if os.path.exists(os.path.join(output_directory, mvc_component_name)):
        print(f"File {mvc_component_name} already exists.")
        return False

    with open(os.path.join(output_directory, mvc_component_name), "w") as f:
        f.write(mvc_component_doc)
        f.write("\n\n# MVC component code goes here" +
                mvc_component.get("file_name", ""))
    return True


def create_directory_structure(controllers, views, output_directory):
    """
    Creates the directory structure for the app.
    """
    os.makedirs(os.path.join(output_directory, "database"))
    os.makedirs(os.path.join(output_directory, "views"))
    os.makedirs(os.path.join(output_directory, "controllers"))

    for controller in controllers:
        create_file(controller, os.path.join(output_directory, "controllers"))

    for view in views:
        create_file(view, os.path.join(output_directory, "views"))

    model_componet_dict = {
        "file_name": "models.py",
        "description": "SQLAlchemy database models.",
        "author": "",
        "usage": "",
        "examples": "",
        "version": "1.0",
        "dependencies": "SQLAlchemy",
    }  # type: ignore
    create_file(model_componet_dict, os.path.join(
        output_directory, "database"))


if __name__ == "__main__":
    arguments = docopt(__doc__)

    filename = arguments["-f"]
    output_directory = arguments["-o"]

    with open(filename, "r") as f:
        data = json.load(f)

    controllers = data["controllers"]
    views = data["views"]
    create_directory_structure(controllers, views, output_directory)
