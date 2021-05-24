#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 30
#SBATCH -N 1
#SBATCH --mem 120000
#SBATCH -t 5-00:00
#SBATCH -J bwa_map_ACGGTC
#SBATCH -o bwa_map_ACGGTC_%j.out
#SBATCH -e bwa_map_ACGGTC_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load bwa/0.7.15-fasrc02
module load samtools/1.5-fasrc02
module load xz/5.2.2-fasrc01 bzip2/1.0.6-fasrc01

#example of BWA aligment on one individual where the plataform ID is @D00742:CCJ7KANXX and the individual barcode ACGGTC. This indiviudal barcode will be the ID of that sample on the final .sam .bam file

bwa mem -t 30 -M -R '@RG\tID:@D00742:CCJ7KANXX\tSM:ACGGTC' Cathbill HC2HMDSXX.4.ACGGTC.unmapped.1.fastq.gz HC2HMDSXX.4.ACGGTC.unmapped.2.fastq.gz > sample.ACGGTC.aln.sam
