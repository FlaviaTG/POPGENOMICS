#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 60
#SBATCH -N 1
#SBATCH --mem 240000
#SBATCH -t 5-00:00
#SBATCH -J genolike
#SBATCH -o genolike_%j.err
#SBATCH -e genolike_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load angsd/0.920-fasrc01

#GENERATE THE GENOTYPES BY LIKELIWOODS
#at samtools style -GL1: SAMtools
#-doGlf 2 : 1: binary glf (10 log likes)	.glf.gz
#-doMajorMinor 1 : Infer major and minor from GL
#-doMajorMinor 4: Use reference allele as major (requires -ref)
#-SNP_pval 1e-6 : If we are interested in looking at allele frequencies only for sites that are actually variable in our sample, we need to perform a SNP calling first. There are two main ways to call SNPs using ANGSD with these options:
#-minMaf         0.000000        (Remove sites with MAF below)
#-SNP_pval       1.000000        (Remove sites with a pvalue larger)
#Therefore we can consider assigning as SNPs sites whose estimated allele frequency is above a certain threhsold (e.g. the frequency of a singleton) or whose probability of being variable is above a specified value.
#-doMaf 1: Frequency (fixed major and minor)

angsd -GL 2 -out genolike1-myspecies -nThreads 60 -doGlf 2 -minInd 28 -doMajorMinor 1 -SNP_pval 1e-6 -minMaf 0.05 -doMaf 1 -minMapQ 30 -minQ 20 -bam List-bam.txt


