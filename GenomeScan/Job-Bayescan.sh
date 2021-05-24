#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --mem 160000
#SBATCH -t 5-00:00
#SBATCH -J bayescan
#SBATCH -o bayescan_%j.out
#SBATCH -e bayescan_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load intel/19.0.5-fasrc01
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

module load Java/1.8.0_201
BA=/path/to/programs/BayeScan2.1_linux64bits

$BA genolike1-myspecies.bayescan -n 5000 -nbp 20 -pilot 5000 -burn 50000 -pr_odds 100 -threads 40 -out_freq -od ./BAYESCAN/
