## Behavgenom basics

### Login

You can interact with jex with a `ssh` shell.

#### If you are working remotely
You cannot connect to jex directly from outside the LMS network, even if you're on the VPN.\
You'll need to contact the LMS IT and ask them to give you access to the Terminal Server. They will configure that for you, and help you set up PuTTY so you can connect to jex, following the instructions below, via the Terminal Server.

#### From within the LMS network
Open a terminal in your local machine and login to Jex, using the command:
``` bash
ssh jex.lms.mrc.ac.uk
```

If you login from a machine other that your own computer (for example from one of the MacPros), use:
``` bash
ssh $user@jex.lms.mrc.ac.uk
```
where `$user` is your username. You will be asked to give your password.

You are now in your personal home directory in jex `/mnt/storage/home/$user$/`




## Using Tierpsy on Jex

This is a summary of the steps one needs to take to run Tierpsy in Jex.\
Here we assume that you are logged into Jex


### Installing Tierpsy on Jex(first time only)

You should install Tierpsy Tracker from source in a virtual environment.
T
On Jex:
``` bash
cd ~
module load miniconda3  # this makes conda available
git clone https://github.com/Tierpsy/tierpsy-tracker
```
``` bash
srun --partition int --qos qos_int --ntasks 1 --cpus-per-task 2 --mem 8G --time 04:00:00 --pty bash -i
cd ~/tierpsy-tracker
conda env create -n tierpsy
source activate tierpsy
pip install -e .
```

