#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

Created on  Dec  5 14:43:56 2023

@author: Weheliye
"""

from pathlib import Path
import os
import argparse
#%%
parser = argparse.ArgumentParser()
parser.add_argument('--input_file', default='tierpsy_output.txt',type=str)
parser.add_argument('--output_file', default='files2process.txt',type=str)
args = parser.parse_args()
print(args.input_file)
src_file = Path(args.input_file)
dst_file = Path(args.output_file)

split_token = '\n*********************************************\n'

with open(src_file) as fid:
    out = fid.read()
#%%
parts = out.split(split_token)
cmds = ['python ' +  x.partition(' ')[-1] for x in parts[4].split('\n')]

with open(dst_file, 'w') as fid:
    fid.write('\n'.join(cmds))
