#!/bin/bash
#SBATCH -p unrestricted
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --ntasks-per-node=1
#SBATCH --mem 160000
#SBATCH -t 1-00:00
#SBATCH -J ADMIXCatharus
#SBATCH -o ADMIXCatharus.out
#SBATCH -e ADMIXCatharus.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load intel/19.0.5-fasrc01
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

ADM=/n/holylfs/LABS/edwards_lab/ftermignoni/programs/admixture_linux-1.3.0/admixture
cd /n/holyscratch01/edwards_lab/ftermignoni/Jclark-reseq/DATA-bam/VCFraw/FinalsVCF


for K in 1 2 3 4 5 6 7 8 9 10; do $ADM -B2000 -j40 --cv Catharus-Thin-ALL.bed $K | tee Bootlog${K}.out; done








