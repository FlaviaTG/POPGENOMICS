#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --ntasks-per-node=1
#SBATCH --mem 160000
#SBATCH -t 2-00:00
#SBATCH -J ADMIX_climacteris
#SBATCH -o ADMIX_climacteris.out
#SBATCH -e ADMIX_climacteris.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load intel/19.0.5-fasrc01
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

ADM=/path/to/program/admixture

for K in 1 2 3 4 5 6 7 8 9 10; do $ADM -B1000 -j40 --cv newNAME-genolike1.bed $K | tee Bootlog${K}.out; done


