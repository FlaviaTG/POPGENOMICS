#!/bin/bash
#SBATCH -p edwards
#SBATCH --mem 32000
#SBATCH -n 8
#SBATCH -N 1
#SBATCH -t 1-00:00
#SBATCH -o countR%j.out
#SBATCH -e countR%j.err
#SBATCH -J countR
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu

module load GCC/8.2.0-2.31.1 SAMtools/1.9


# file header  
echo "bam_file total mapped unmapped"

# loop to count reads in all files and add results to a table  
for bam_file in *.bam  
do  
total=$(samtools view -c $bam_file)  
mapped=$(samtools view -c -F 4 $bam_file)  
unmapped=$(samtools view -c -f 4 $bam_file)  
echo "$bam_file $total $mapped $unmapped" >> MappedReads.txt 
done  
# ultimately the data is saved in a space-separated file

