#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 60
#SBATCH -N 1
#SBATCH --mem 240000
#SBATCH -t 5-00:00
#SBATCH -J SFS-LOCAL
#SBATCH -o SFS-LOCAL_%j.err
#SBATCH -e SFS-LOCAL_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load angsd/0.920-fasrc01
#the referenge genome file
REFPATH=/path/to/referencegenome.fasta
#the filter options map quality depth read and type of calculation GENOTYPES LIKELIWOODS
FILTERS="-minMapQ 30 -minQ 20"
OPT="-doSaf 1 -gl 2"

#first generate the genotypes or count aleles on each species in a loop
for i in $(ls *LOCAL.txt); do angsd -bam $i -anc $REFPATH -out $i $FILTERS $OPT -ref $REFPATH -nThreads 60; done

#Second calculates the SFS for each species in a loop
#for i in $(ls *saf.idx); do realSFS $i -maxIter 100 -P 60 > $i.sfs; done

