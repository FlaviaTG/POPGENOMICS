#run it on interactive session, do not need a job, will take several minutes (~7min)
#need java module to run PGDSpider
module load jdk/10.0.1-fasrc01
module load Java/1.8.0_201

#need to have a .spid file with the format configuration parameteres. See the included file example named:
SPID=/path/to/programs/example-bayescan-format.spid
PGD=/path/to/programs/PGDSpider_2.1.1.5/PGDSpider2-cli.jar

#first need to prune the SNPs to for this analysis, on windows base 10kb, 20kb etc. on vcftools for example

###format with PGD vcf to bayescan
java -Xmx32000m -Xms512m -jar $PGD -inputfile genolike-pruned.vcf -inputformat VCF -outputfile genolike-pruned.bayescan -outputformat GESTE_BAYE_SCAN -spid $SPID

