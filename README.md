# Behavgenom_jex
This behave genom


``` bash
srun --partition int --qos qos_int --ntasks 1 --cpus-per-task 2 --mem 8G --time 04:00:00 --pty bash -i
cd ~/tierpsy-tracker
conda env create -n tierpsy
source activate tierpsy
pip install -e .
```

