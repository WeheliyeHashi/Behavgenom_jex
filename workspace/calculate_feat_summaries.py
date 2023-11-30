#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue  11:22:38 2023

@author: Weheliye
"""

from tierpsy.summary.collect import calculate_summaries
import sys

root_dir = sys.argv[1]

print('Caluclating feature summaries for directory: \n{}'.format(root_dir))

is_manual_index = False
feature_type = 'tierpsy'
summary_type = 'plate' # 'plate_augmented' # 'trajectory'

#fold_args = dict(n_folds = 2, frac_worms_to_keep = 0.8, time_sample_seconds = 10*60)
filter_args = {
    'filter_time_min': '',
    'filter_travel_min': '',
    'filter_time_units': 'frame_numbers',
    'filter_distance_units': 'microns',
    'filter_length_min': '700',
    'filter_length_max': '1300',
    'filter_width_min': '20',
    'filter_width_max': '200'
    }
#kwargs = dict(fold_args, **filter_args)

time_windows = '0:end' #'0:end:1000' #'0:end' #
time_units = 'seconds'
select_feat = 'all' #'tierpsy_2k'
keywords_include = ''
keywords_exclude = '' #'curvature,velocity,norm,abs'
abbreviate_features = False
dorsal_side_known = False

df_files = calculate_summaries(
    root_dir, feature_type, summary_type, is_manual_index,
    abbreviate_features, dorsal_side_known,
    time_windows=time_windows, time_units=time_units,
    select_feat=select_feat, keywords_include=keywords_include,
    keywords_exclude=keywords_exclude,
    _is_debug = False,n_parallel=10,  append_to_file=None, **filter_args)
