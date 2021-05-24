#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 48
#SBATCH -N 1
#SBATCH --mem 184000
#SBATCH -t 4-00:00
#SBATCH -J thetaLOCAL
#SBATCH -o thetaLOCAL_%j.err
#SBATCH -e thetaLOCAL_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load angsd/0.920-fasrc01
#need to calculate SFS first
#calculate theta to all angsd SFS for each species

for i in $(ls *LOCAL.txt.saf.idx); do echo $i
       j=`echo $i | sed 's/.txt.saf.idx/.txt.saf.idx.sfs/'`
       realSFS saf2theta $i -sfs $j -maxIter 100 -P 48 -outname $i_Folded; done
