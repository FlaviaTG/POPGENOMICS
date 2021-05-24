module load jdk/1.8.0_172-fasrc01
#programs to use
module load GCC/7.3.0-2.30 OpenMPI/3.1.1 BCFtools/1.9
module load jdk/1.8.0_172-fasrc01
module load vcftools/0.1.14-fasrc01
module load GCC/8.2.0-2.31.1 SAMtools/1.9
module load tabix/0.2.6-fasrc01

#need the path to the reference genome index file
MB=/path/to/genomes/referencegenome.fasta.fai
gtool=/path/to/programs/glactools/glactools
BPATH=/path/to//programs/beagle.18May20.d20.jar

#need to format the beagle output from ANGSD to vcf and phase it.

#Beagle file with GL to vcf in 3 steps. You can find a Slurm Job example for this in: Job-beagle-Formating.sh
$gtool beagle2glf --fai $MB genolike.beagle.gz > All.glf.gz
$gtool glf2acf All.glf.gz > All.acf.gz
$gtool glac2vcf All.acf.gz > All.vcf.gz
#
#
bcftools view --header-only All.vcf 
#reheader in necesary
bcftools reheader -s new-header-vcf.txt  All.vcf > newH-All.vcf
#Phase it with Beagle. You can find a Slurm Job example for this in:  
java -Xmx20000m -jar $BPATH gt=newH-All.vcf out=All-PHASED
#bcftools index the vcf file generated
bcftools index All-PHASED.vcf
#
#subset per subespecies, with vcftools where pop_map-species1.txt is the list of individuals for that subespecies subset
vcftools --vcf newH-All.vcfz --keep pop_map-species1.txt --max-missing 1 --recode --recode-INFO-all --out newH-genolike_species1-PHASED
#
vcftools --vcf newH-All.vcfz --keep pop_map-species2.txt --max-missing 1 --recode --recode-INFO-all --out newH-genolike_species2-PHASED
########split per chromosomes each subset per species, where CHROM-autosome.txt has the list of the chromosomes to subset.
for i in $(cat CHROM-autosome.txt); do vcftools --gzvcf newH-genolike_species1-PHASED.vcf --chr $i --recode --recode-INFO-all --out ./CHROM/species1_$i
##################################################################
#########haplotype genome scan with rehh in R ####################
#Now that you have separete files, the format and phased genotypes, you can run in R rehh genome scan
###make a test like this and if it works, you will need to make a R script to run it on all chromosomes. See the example script: Rehh-RUN-CHR1.R
library(rehh)
library(tidyverse)
# read in data for each species
# house
house_hh <- data2haplohh(hap_file = "newH-genolike_species1-PHASED-CHR1.vcf",
                         polarize_vcf = FALSE)
# bactrianus
bac_hh <- data2haplohh(hap_file = "newH-genolike_species2-PHASED-CHR1.vcf",
                         polarize_vcf = FALSE)
# filter on MAF - here 0.05
house_hh_f <- subset(house_hh, min_maf = 0.05)
bac_hh_f <- subset(bac_hh, min_maf = 0.05)
# perform scans
house_scan <- scan_hh(house_hh_f, polarized = FALSE)
bac_scan <- scan_hh(bac_hh_f, polarized = FALSE)
# perform iHS on house
house_ihs <- ihh2ihs(house_scan, freqbin = 1)
bac_ihs <- ihh2ihs(bac_scan, freqbin = 1)
#plot statistics
pdf("Chr1.pdf")
ggplot(house_ihs$ihs, aes(POSITION, IHS)) + geom_point()
#Or we can plot the log P-value to test for outliers.
ggplot(house_ihs$ihs, aes(POSITION, LOGPVALUE)) + geom_point() + geom_hline(yintercept=5, linetype="dashed", color = "red")
ggplot(bac_ihs$ihs, aes(POSITION, LOGPVALUE)) + geom_point() + geom_hline(yintercept=5, linetype="dashed", color = "red")
#############
####################with both
# perform xp-ehh
house_bac <- ies2xpehh(bac_scan, house_scan,
                       popname1 = "species1", popname2 = "species2",
                       include_freq = T,standardize = TRUE)
# plot
ggplot(house_bac, aes(POSITION, XPEHH_bicknell_minimus)) + geom_point()
ggplot(house_bac, aes(POSITION, LOGPVALUE)) + geom_point() + geom_hline(yintercept=5, linetype="dashed", color = "red")
#
ggplot(ext, aes(POSITION, LOGPVALUE)) + geom_point() + geom_hline(yintercept=5, linetype="dashed", color = "red")
###
# find the highest hit
hit <- house_bac %>% arrange(desc(LOGPVALUE)) %>% top_n(1)
# get SNP position
x <- hit$POSITION
marker_id_h <- which(house_hh_f@positions == x)
marker_id_b <- which(bac_hh_f@positions == x)
#Now we are ready to plot the bifurcation of haplotypes around our site of selection. We do this like so:

house_furcation <- calc_furcation(house_hh_f, mrk = marker_id_h)
bac_furcation <- calc_furcation(bac_hh_f, mrk = marker_id_b)

#We can also plot both of these to have a look at them:

plot(house_furcation, xlim = c(19.18E+6, 19.22E+6))
plot(bac_furcation, xlim = c(19.18E+6, 19.22E+6))

#Calculating the furcation pattern also makes it possible to calculate the haplotype length around our signature of selection.

house_haplen <- calc_haplen(house_furcation)
bac_haplen <- calc_haplen(bac_furcation)

#With the haplotype length calculated, we can now plot this to)
# see how haplotype structure differs between our two populations.

plot(house_haplen)
plot(bac_haplen)

# write out house bactrianus xpEHH table to plot it later
house_bac <- tbl_df(house_bac)
colnames(house_bac) <- tolower(colnames(house_bac))
write_tsv(house_bac, "./Chr1-minimus-bicknell_xpEHH.tsv")
dev.off()
