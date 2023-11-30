#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon 19:48:25 2023

@author: Weheliye
"""
#%%
from pathlib import Path
from datetime import datetime
import re
import argparse

#%%
parser = argparse.ArgumentParser()
parser.add_argument('--input_file', default='Results_folder',type=str)
parser.add_argument('--output_file', default='files2process.txt',type=str)
parser.add_argument('--file_2_process', default='calculate_feat_summaries.py')

args = parser.parse_args()
root = Path(args.input_file)



with open(args.output_file, "w") as fid:
    fid.write(f'python {args.file_2_process} {root}')
   
   

# %%
