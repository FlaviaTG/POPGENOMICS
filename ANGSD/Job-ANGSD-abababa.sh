#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 40
#SBATCH -N 1
#SBATCH --mem 160000
#SBATCH -t 2-00:00
#SBATCH -J ABBABABA
#SBATCH -o ABBABABA_%j.err
#SBATCH -e ABBABABA_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

#run your personal installation of R to get all the ouputs
module load gcc/8.2.0-fasrc01 R/3.6.1-fasrc02
export R_LIBS_USER=$HOME/app/R_3.6:$R_LIBS_USER
module load GCC/8.2.0-2.31.1 SAMtools/1.9
module load angsd/0.930-fasrc01

REFPATH=/path/to/referencegenome.fasta

#prepare error files
#angsd -doAncError 1 -anc Custulatus.fa -ref $REFPATH -out errorFile -bam bamWithErrors.filelist
#run test
# useLast is expectig to get the outgroup sample at the last of the  .filelist
#angsd -doAbbababa2 1 -bam map_Catharus-all.filelist -sizeFile sizeFile.size -doCounts 1 -out minimus_bam.Angsd -useLast 1 -enhance 1 -nThreads 40
angsd -out Catharus -doAbbababa 1 -bam Catharus-abba.filelist -doCounts 1 -useLast 1 -enhance 1 -nThreads 40
