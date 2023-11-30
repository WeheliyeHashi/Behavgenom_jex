#! /bin/bash
#SBATCH --job-name=analysis
#SBATCH --partition=cpu
#SBATCH --time=20:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --output=/dev/null
#SBATCH --mem=32G
module load miniconda3
conda activate tierpsy
FILESSOURCE=$1

echo "Username: " `whoami`
FSOURCE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $FILESSOURCE)
echo ${FSOURCE}
eval $FSOURCE

exit 0


