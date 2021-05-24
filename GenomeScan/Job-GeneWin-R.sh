#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 0-01:00
#SBATCH -J GeneWin
#SBATCH -o GeneWin_%j.out
#SBATCH -e GeneWin_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load gcc/8.2.0-fasrc01 R/3.6.1-fasrc02
export R_LIBS_USER=$HOME/app/R_3.6:$R_LIBS_USER

#to run all your R scripts per chromosome at the same time 
for i in GeneWin-CHR*.R;do R CMD BATCH --quiet --no-restore --no-save $i outputfile_GeneWin$i;done

