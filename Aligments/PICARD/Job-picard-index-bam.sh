#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 16
#SBATCH -N 1
#SBATCH --mem 64000
#SBATCH -t 3-00:00
#SBATCH -J Picard-index-bam
#SBATCH -o Picard-index-bam_%j.out
#SBATCH -e Picard-index-bam_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load centos6/0.0.1-fasrc01
module load java/1.8.0_45-fasrc01
module load jdk/1.8.0_45-fasrc01
module load gatk/4.0.2.1-fasrc01
module load samtools/1.5-fasrc02
module load picard/2.9.0-fasrc01

PICPATH=/path/to//programs/picard.jar

#in a loop index al bam files generated after aligment bwa

for sample in *.sam.sort.bam.dedup.bam
        do java -Xmx64g -XX:ParallelGCThreads=16 -jar $PICPATH BuildBamIndex I=$sample ;done


