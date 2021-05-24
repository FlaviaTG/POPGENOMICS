#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem 80000
#SBATCH -t 1-00:00
#SBATCH -J SNP-select
#SBATCH -o SNP-select.out
#SBATCH -e SNP-select.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent


module load samtools/1.5-fasrc02
module load jdk/10.0.1-fasrc01

GATKPATH=/path/to/programs/gatk-4.1.4.0/gatk-package-4.1.4.0-local.jar
REFPATH=/path/to/referencegenome.fasta

java -Xmx80g -XX:ParallelGCThreads=20 -jar $GATKPATH SelectVariants \
    -R $REFPATH \
    -V all_samples_combined.vcf \
    --select-type-to-include SNP \
    -O all_samples_combined-raw_snps.vcf
