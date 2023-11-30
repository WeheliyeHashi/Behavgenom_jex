#!/bin/bash

echo "Welcome"
read -p "Please enter your name and project (e.g. Weheliye_GPCR): " name_of_project

if [[ -z ${name_of_project} ]]; then
    name_of_project="behavgenom_analysis"
fi
echo 'Enter the directory to the RawVideos'



read -p "/Volumes/behavgenom\$/" name_raw_dir



if [[ ! $name_raw_dir =~ "RawVideos" ]]; then
    echo "The RawVideos folder is not on the path provided and the terminal will be terminated"
    exit 0
fi 

if [[ ! -e "$HOME/mnt/network/behavgenom/${name_raw_dir}" ]]; then 
    echo "The RawVideos path doesn't exist and the terminal will be terminated"
    exit 0
fi 

#  Select the parameters file 
PS3='Please enter your choice of well parameters file: '
options=("24" "96" "custom")
select opt in "${options[@]}"
do
    case $opt in
        "24")
            echo "you chose choice $opt parameters file"
            params_file_name=$opt
            break
            ;;
        "96")
            echo "you chose choice $opt parameters file"
            params_file_name=$opt
            break
            ;;
        "custom")
            echo "you chose $opt parameters file"
            params_file_name=$opt
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


if [[ ${params_file_name} = 96 ]]; then 
    path_file="$HOME/mnt/network/behavgenom/Documentation/Protocols/analysis/Parameters_files/loopbio_rig_96WP_splitFOV_NN_20220310.json"
    echo "The parameters file selected is a 96 plate well : ${path_file}"
elif [[ ${params_file_name} = 24 ]]; then
    path_file="$HOME/mnt/network/behavgenom/Documentation/Protocols/analysis/Parameters_files/loopbio_rig_24WP_splitFOV_NN_20220202.json"
    echo "The parameters file selected is a 24 well : ${path_file}"
elif [[ ${params_file_name} = "custom" ]]; then
    echo "Please enter a full custom parameters file directory"
    read -p "$HOME/mnt/network/behavgenom/" path_file_custom
    echo "The parameters file selected is a custom well : ${path_file_custom}"
    path_file="$HOME/mnt/network/behavgenom/${path_file_custom}"
else 
    echo "No parameters file was selected. The terminal will be terminated"
    exit 0
fi
   

#  Check if the parameters file path exist 

if [[ ! ${path_file} = *.json ]] && [[ ! -e ${path_file} ]]; then
    echo "Sorry $USER! no parameter file with *.json was found"
    exit 0
fi 

mkdir -p "$HOME/mnt/network/behavgenom/${name_raw_dir/RawVideos/log}/files2process"
log_dir=("$HOME/mnt/network/behavgenom/${name_raw_dir/RawVideos/log}/files2process")
echo "Please wait for few minutes until we fetch all the files to process"
Time_stamp=$( date +%Y%m%d_%H%M_%S )

module load miniconda3
conda activate tierpsy
tierpsy_process --video_dir_root "$HOME/mnt/network/behavgenom/${name_raw_dir}" \
 --mask_dir_root "$HOME/mnt/network/behavgenom/${name_raw_dir/RawVideos/MaskedVideos}" \
 --results_dir_root "$HOME/mnt/network/behavgenom/${name_raw_dir/RawVideos/Results}" \
 --only_summary \
 --max_num_process 10\
 --tmp_dir_root ''\
 --pattern_include "*.yaml" \
 --json_file "$path_file" \
 --is_debug --copy_unfinished | tee "$log_dir/tierpsy_output_$Time_stamp.txt"

python $PWD/Behavgenom_jex/workspace/filter_files2process.py --input_file="$log_dir/tierpsy_output_$Time_stamp.txt" --output_file="$log_dir/files2process_$Time_stamp.txt"


num_files=$(cat $log_dir/files2process_$Time_stamp.txt | wc -l)
(( num_files++ ))


num_cols=$(cat $log_dir/files2process_$Time_stamp.txt | awk '{print NF}' | head -1)



if [[ $num_cols = 1 ]]; then
   echo "All your files were succesfully processed and WILL NOT BE SUBMITTED"
   exit 0
else
   results_flder="$HOME/mnt/network/behavgenom/${name_raw_dir}"
   echo "RawVideos: $HOME/mnt/network/behavgenom/${name_raw_dir}" >>"$(dirname $log_dir )/log.txt"
   echo "The parameter file is a ${params_file_name} well ($(basename $path_file)) " >>"$(dirname $log_dir )/log.txt"
   echo "The number of files to process: ${num_files}" >>"$(dirname $log_dir )/log.txt" 
   python $PWD/Behavgenom_jex/workspace/write_cmds2process.py --input_file="${results_flder%RawVideos*}/Results" --output_file="$log_dir/featsummaries2process_$Time_stamp.txt" --file_2_process="$PWD/Behavgenom_jex/workspace/calculate_feat_summaries.py"
   jobid=$(sbatch --parsable --job-name=$name_of_project --array 1-$num_files ./Behavgenom_jex/workspace/process_all_slurm.q $(realpath $log_dir/files2process_$Time_stamp.txt))
   echo "Your batch processing job number is ${jobid}" >>"$(dirname $log_dir )/log.txt" 
   jobid_sum=$(sbatch --job-name=$name_of_project --output="$(dirname $log_dir)/feat_summ_$Time_stamp.log" --parsable --dependency afterok:${jobid} ./Behavgenom_jex/workspace/process_feat_summary.q $(realpath $log_dir/featsummaries2process_$Time_stamp.txt))
   echo "Your feature summary job is ${jobid_sum}" >>"$(dirname $log_dir )/log.txt" 
   echo "Your Jobs have successfully been submitted"
fi
