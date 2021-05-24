#!/bin/bash
#SBATCH -p edwards
#SBATCH -n 30
#SBATCH -N 1
#SBATCH --mem 180000
#SBATCH -t 5-00:00
#SBATCH -J Format
#SBATCH -o Format_%j.err
#SBATCH -e Format_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

cd /n/holyscratch01/edwards_lab/ftermignoni/Jclark-reseq/BWA-chr/bamOUTsex

module load jdk/1.8.0_172-fasrc01
module load GCC/7.3.0-2.30 OpenMPI/3.1.1 BCFtools/1.9
module load jdk/1.8.0_172-fasrc01
module load vcftools/0.1.14-fasrc01
#module load GCC/8.2.0-2.31.1 SAMtools/1.9
module load tabix/0.2.6-fasrc01

#indicate variables path to programs
gtool=/path/to/programs/glactools/glactools
BPATH=/path/to/programs/beagle.18May20.d20.jar
#indicate path to the reference genome index file
REFPATH=/path/to/referencegenome.fai

#Transform the beagle format file from ANGSD with genotype liklihoods into a VCF file 
#run each step one by one. Check the output file from one step needs to be the input of the next step

#step 1#
#$gtool beagle2glf --fai $REFPATH genolike_34_minimus-AUTOSOME > genolike_34_minimus-AUTOSOME.glf.gz

#step 2#
#$gtool glf2acf genolike_34_minimus-AUTOSOME.glf.gz > genolike_34_minimus-AUTOSOME.acf.gz

#step 3#
$gtool glac2vcf genolike_34_minimus-AUTOSOME.acf.gz > genolike_34_minimus-AUTOSOME.vcf


