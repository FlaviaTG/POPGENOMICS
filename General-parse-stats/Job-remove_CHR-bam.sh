#!/bin/bash
#SBATCH -p edwards
#SBATCH --mem 32000
#SBATCH -n 8
#SBATCH -N 1
#SBATCH -t 1-00:00
#SBATCH -o ChrOUT%j.out
#SBATCH -e ChrOUT%j.err
#SBATCH -J ChrOUT
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu

module load GCC/8.2.0-2.31.1 SAMtools/1.9

#to remove chromosomes/scaffolds/contigs from all your aligments .bam
#make a list of the chromosomes of interest that you want out of the aligment in this example are the sex chromosomes : SEX-Chr.list
#this will save in a folder vall bamOUTsex
#if you want to select insted of remove, just need to remove "-v" in grep

for file in *remove.bam ; do samtools idxstats $file | cut -f 1 | grep -v -w -f SEX-Chr.list | xargs samtools view -b $file > ./bamOUTsex/$file.OUT.SEX.CHR.bam; done
