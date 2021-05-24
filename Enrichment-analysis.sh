#getting the closes gene to a list of outlier regions or SNPs.
#modules to use
module load bedtools2/2.26.0-fasrc01
module load gcc/7.1.0-fasrc01 bedops/2.4.25-fasrc01

# take the closes feature to the outlier. To do this the list of SNPs or regions needs to be a two columns wit hthe name of the marker and the position on the reference genome. Also, need to provide the .gff annotiation file from the reference genome 
#both files need to be converted as .bed files like this:
convert2bed -i gff < reference.gff > reference.gff.bed
#also need to be sorted the new generated .bed files
#order sort the snp.bed file
for i in *.bed;do sortBed -i ourlierRegions.bed;done
#run bedtools
#just geting the closest and format for enrichment analyses at the same time. Getting up and down regulated too
closestBed -d -k 2 -mdb each -a ourlierRegions.bed -b reference.gff.bed > CLOSEST-genes.txt
#in loops all closest with distance downstream
closestBed -iu -d -D b -k 2 -mdb each -a ourlierRegions.bed -b reference.gff.bed > CLOSEST-DOWN.txt
#in loops all closest with distance upstream
closestBed -id -d -D b -k 2 -mdb each -a ourlierRegions.bed -b reference.gff.bed > CLOSEST-UP.txt
#the outputs need to be formated before running on allenricher
cut -f 13 CLOSEST-genes.txt | tr ';' '\n'| grep -o -P '(gene=).*' |sort| uniq  > genelist.list
#in this columns you can get the distance of each feature for plotting
cut -f 1,14 genelist.list > feature-DISTANCE.txt
#remove other words to have the correct format for allenricher
sed -i 's/gene=//g' genelist.list
##############
################Enrichment analysis################################
#load module
module load GCCcore/8.2.0 Perl/5.28.0
#download the clone of AllEnricher
git clone https://github.com/zd105/AllEnricher.git
#need to create an envirionment to run this program AllEnricher
conda create -n AllEnricher
conda activate AllEnricher
conda install -c conda-forge perl 
conda install -c bioconda perl-perlio-gzip 
conda install -c bioconda perl-findbin 
#in the new environment install the program
./install.sh -P /path/to/your/.conda/envs/AllEnricher/bin/perl -R $(command -v Rscript)
./make_GOdb
./update_GOdb
#path to the program
AE=/path/to/AllEnricher-master/AllEnricher
#run AllEnrichment to the gene list you create before with bedtools
perl $AE -l genelist.list -s gga -n 1 -i GO -o ./allenricher/genelist -r $(command -v Rscript)
#
