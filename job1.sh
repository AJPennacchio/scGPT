#!/bin/bash
#$ -S /bin/bash      # the shell language when run via the job scheduler
#$ -cwd               # job should run in the current working directory
#$ -j y               # STDERR and STDOUT should be joined
#$ -l mem_free=10G     # job requires up to 250 GiB of RAM per slot, 550
#$ -l scratch=10G      # job requires up to 200 GiB of local /scratch space
#$ -l h_rt=6:00:00    # job requires up to 4 hours of runtime

# Mount the current directory to the container
# Any directory that needs to be accessed by the container should be mounted
directory=/wynton/home/yang/apennacchio/scGPT
export APPTAINER_BINDPATH="$directory"

module load cuda 

echo "SGE_GPU: $SGE_GPU"
export CUDA_VISIBLE_DEVICES=$SGE_GPU
nvcc -V

apptainer run --nv scgpt_0.2.1.sif python3 $directory/scripts/batch_integration.py
# apptainer run --nv scgpt_0.1.7.sif python3 $directory/scripts/ct_annotation.py  

[[ -n "$JOB_ID" ]] && qstat -j "$JOB_ID"
