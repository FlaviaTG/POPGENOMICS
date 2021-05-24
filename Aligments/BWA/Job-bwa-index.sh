#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 30
#SBATCH -N 1
#SBATCH --mem 120000
#SBATCH -t 1-00:00
#SBATCH -J bwa_index
#SBATCH -o bwa_index_%j.out
#SBATCH -e bwa_index%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load bwa/0.7.15-fasrc02
module load samtools/1.5-fasrc02
module load xz/5.2.2-fasrc01 bzip2/1.0.6-fasrc01

GB=referencegenome.fasta

bwa index -p Cathmin $GB
