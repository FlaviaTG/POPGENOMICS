#!/bin/bash
#SBATCH -p remotedesktop
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 1-05:00
#SBATCH -J SNP-select
#SBATCH -o SNP-select_%j.out
#SBATCH -e SNP-select_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent


module load samtools/1.5-fasrc02
module load jdk/10.0.1-fasrc01

GATKPATH=/path/to/programs/gatk-4.1.4.0/gatk-package-4.1.4.0-local.jar
REFPATH=/path/to/referengegenome.fasta

#hard filter to all my SNPs, depth, quality and errors sequencing, 

java -Xmx40g -XX:ParallelGCThreads=10 -jar $GATKPATH VariantFiltration \
    -R $REFPATH \
    -V all_samples_combined_raw_snps.vcf \
    --filter-expression "!vc.hasAttribute('DP')" \
    --filter-name "noCoverage" \
    --filter-expression "vc.hasAttribute('DP') && DP < MINDEPTH" \
    --filter-name "MinCov" \
    --filter-expression "vc.hasAttribute('DP') && DP > MAXDEPTH" \
    --filter-name "MaxCov" \
    --filter-expression "(vc.isSNP() && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -8.0)) || ((vc.isIndel() || vc.isMixed()) && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -20.0)) || (vc.hasAttribute('QD') && QD < 2.0) " \
    --filter-name "badSeq" \
    --filter-expression "(vc.isSNP() && ((vc.hasAttribute('FS') && FS > 60.0) || (vc.hasAttribute('SOR') &&  SOR > 3.0))) || ((vc.isIndel() || vc.isMixed()) && ((vc.hasAttribute('FS') && FS > 200.0) || (vc.hasAttribute('SOR') &&  SOR > 10.0)))" \
    --filter-name "badStrand" \
    --filter-expression "vc.isSNP() && ((vc.hasAttribute('MQ') && MQ < 40.0) || (vc.hasAttribute('MQRankSum') && MQRankSum < -12.5))" \
    --filter-name "badMap" \
    -O all_samples_combined_raw_snps_filtered_snps.vcf
