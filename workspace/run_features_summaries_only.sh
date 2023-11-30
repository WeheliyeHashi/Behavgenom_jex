#!/bash/bin 

echo "Welcome"
read -p "Please enter your name and project (e.g. Weheliye_GPCR): " name_of_project

if [[ -z ${name_of_project} ]]; then
    name_of_project="behavgenom_analysis"
fi
echo 'Enter the directory to the Results folder'



read -p "/Volumes/behavgenom\$/" name_results_dir


### Simple check to see if the folder exists and the name results appear 

if [[ ! $name_results_dir =~ "Results" ]]; then
    echo "The Results folder is not on the path provided and the terminal will be terminated"
    exit 0
fi 


if [[ ! -e "$HOME/mnt/network/behavgenom/${name_results_dir}" ]]; then 
    echo "The Results path (folder) doesn't exist and the terminal will be terminated"
    exit 0
fi 

Time_stamp=$( date +%Y%m%d_%H%M_%S )
log_dir=("$HOME/mnt/network/behavgenom/${name_results_dir/Results/log}/files2process")
if [[ ! -e ${log_dir} ]]; then 
    echo "The log path (folder) doesn't exist and a new one will be created"
    mkdir -p ${log_dir}
fi 

module load miniconda3
conda activate tierpsy

python $PWD/Behavgenom_jex/workspace/write_cmds2process.py --input_file="$HOME/mnt/network/behavgenom/${name_results_dir}" --output_file="$log_dir/featsummaries2process_$Time_stamp.txt" --file_2_process="$PWD/Behavgenom_jex/workspace/calculate_feat_summaries.py"
sbatch --job-name=$name_of_project --output="$(dirname $log_dir)/feat_summ_$Time_stamp.log" ./Behavgenom_jex/workspace/process_feat_summary.q $(realpath $log_dir/featsummaries2process_$Time_stamp.txt) >>"$(dirname $log_dir )/log_featsumm.txt"
echo "This is only for feature summary only. Length of constrain 700 to 1300 microns. Width constrain is 20 to 200 microns" >>"$(dirname $log_dir )/log_featsumm_parameters.txt"

echo "Feature summaries have been succesfully submitted"
