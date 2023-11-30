module load miniconda3
conda activate tierpsy
tierpsy_process --video_dir_root "$HOME/testvideo/RawVideos" \
 --mask_dir_root "$HOME/testvideo/MaskedVideos" \
 --results_dir_root "$HOME/testvideo/Results" \
 --only_summary \
 --json_file "$HOME/AuxiliaryFiles/loopbio_rig_96WP_splitFOV_NN_20220310.json" \
 --pattern_include "*.yaml" \
 --is_debug --copy_unfinished | tee "$HOME/workspace/tierpsy_output.txt"

python $HOME/workspace/filter_files2process.py
