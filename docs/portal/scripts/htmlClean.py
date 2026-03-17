#!/usr/bin/env python3
"""

Modifies HTML files as necessary during docs processing and building.
Currently just removes the "title" attribute, which was appearing in xref links

"""

import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("HTML_DIR", help="Path of directory containing exported HTML files")
args = parser.parse_args()

with os.scandir(args.HTML_DIR) as dir:
        for entry in dir:
                if entry.is_file() and entry.name != "temp_file" and entry.name.split(".")[-1] == "html":
                    with open(entry, 'r+', encoding="utf-8") as current_file:
                        current_file_string = current_file.read()  
                        title_att = False
                        title_string_lst = []
                        title_start = 0
                        title_end = 0
                        if r'title="' in current_file_string:
                            title_att = True
                            while title_att == True:
                                title_start = current_file_string.find(r'title="', title_start) - 1
                                title_end = current_file_string.find(r'"', title_start + 8)
                                title_string = current_file_string[title_start:title_end + 1]
                                title_string_lst.append(title_string)
                                title_start = title_end
                                if r'title="' not in current_file_string[title_start:]:
                                    title_att = False
                            for string in title_string_lst:
                                current_file_string = current_file_string.replace(string, "")
                    with open(entry, 'w', encoding="utf-8") as updated_file:
                        updated_file.write(current_file_string)  