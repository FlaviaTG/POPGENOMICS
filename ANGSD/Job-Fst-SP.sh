#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 60
#SBATCH -N 1
#SBATCH --mem 240000
#SBATCH -t 4-00:00
#SBATCH -J Fst-SP
#SBATCH -o Fst-SP_%j.err
#SBATCH -e Fst-SP_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load angsd/0.920-fasrc01

#taking the index files output from the angsd generate file from the GENOTYPES LIKELIWOODS to generate input files for Fst calculations such as theta.

#step1# 
# index both species in the final bidimensional sfs
#firt need to calculate SFS
#realSFS fst species1.saf.idx species2.saf.idx -sfs 2dsfsMB-all.sfs -fstout species1-species2 
#calculate fst genome wide on windows
realSFS fst stats2 species1-species2.fst.idx -win 20000 -step 10000 > slidingwindowBackground-species1-species2-20kb-10kb

