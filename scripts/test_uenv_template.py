"""
@brief     
@details   
@author    Mathew Cosgrove
@date      Thursday January 18th 2024
@file      test_uenv_template.py
@copyright (c) 2024 NORTHROP GRUMMAN CORPORATION
-----
Last Modified: 01/18/2024 04:30:14
Modified By: Mathew Cosgrove
-----
"""
from jinja2 import BaseLoader, TemplateNotFound
from os.path import join, exists, getmtime

from jinja2 import Environment, FileSystemLoader, select_autoescape
import os
DESIGN_PATH = "/home/cosgrma/workspace/sergeant/designs/root"
SMAKE_PATH = os.path.join(DESIGN_PATH, "smake")

env = Environment(
    loader=FileSystemLoader(os.path.join(SMAKE_PATH, "util")),
    autoescape=select_autoescape()
)

template = env.get_template("uEnv_template.j2")

uenv_config = {
    "vx_img_filename": "uVxWorks",
    "fpga_file": "system.bit",
    "dtb_filename": "system.dtb",
    "ftp_user": "root",
    "dns_server_ip": "192.168.2.1",
    "gatewayip": "192.168.2.1",
    "serverip": "192.168.2.18",
    "ftpserverip": "192.168.2.18",
    "board": "ngc_magnompnt",
}
content = template.render(uenv_config=uenv_config)

print(content)

# for student in students:
#     filename = f"message_{student['name'].lower()}.txt"
#     content = template.render(
#         student,
#         max_score=max_score,
#         test_name=test_name
#     )
#     with open(filename, mode="w", encoding="utf-8") as message:
#         message.write(content)
#         print(f"... wrote {filename}")

