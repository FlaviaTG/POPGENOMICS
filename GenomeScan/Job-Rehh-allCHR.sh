#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 40
#SBATCH -N 1
#SBATCH --mem 160000
#SBATCH -t 10-00:00
#SBATCH -J rehh
#SBATCH -o rehh_%j.out
#SBATCH -e rehh_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load gcc/8.2.0-fasrc01 R/3.6.1-fasrc02
export R_LIBS_USER=$HOME/app/R_3.6:$R_LIBS_USER

for i in Rehh-RUN-CHR*; do R CMD BATCH --quiet --no-restore --no-save $i outputfile_rehh_$i;done
