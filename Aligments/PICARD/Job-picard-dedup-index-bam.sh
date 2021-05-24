#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 32
#SBATCH -N 1
#SBATCH --mem 128000
#SBATCH -t 3-00:00
#SBATCH -J Picard-sort-index-bam
#SBATCH -o Picard-sort-index-bam_%j.out
#SBATCH -e Picard-sort-index-bam_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load centos6/0.0.1-fasrc01
module load java/1.8.0_45-fasrc01
module load jdk/1.8.0_45-fasrc01
module load gatk/4.0.2.1-fasrc01
module load samtools/1.5-fasrc02
module load picard/2.9.0-fasrc01

PICPATH=/path/to//programs/picard.jar

#in a loop mark duplicates to each bam file
#to do it your bam siles need to be indexed and ordered with samtools or same picard

for sample in *.alnCHR.sam.sort.bam.dedup.remove.bam 
	do java -Xmx128g -XX:ParallelGCThreads=32 -jar $PICPATH MarkDuplicates TMP_DIR=tmp I=$sample O=$sample.dedup.bam METRICS_FILE=$sample.dedup.metrics.txt REMOVE_DUPLICATES=false TAGGING_POLICY=All;done
