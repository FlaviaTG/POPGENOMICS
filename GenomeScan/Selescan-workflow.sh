#programs to use
SEL=/path/to/programs/selscan
NORM=/path/to/programs/selescan/norm
PLI=/path/to/programs/plink

#first subset vcf files per chomosomes and species separate this can be done very easy with vcftools.
#then creat the map and bed files with PLINK for each file, in a loop like this:
for i in chromosome-*.vcf; do $PLI --vcf $i --geno 0.999 --recode --no-fid --no-parents --no-sex --no-pheno --out $i --allow-extra-chr 0 --noweb --make-bed;done

#run selescan per chromosomes and per species to compare in the cross population analysis --xpnsl
#for example in one chromosomes one species
$SEL --nsl --vcf species1-CHR1.vcf 

###now that you know it worked well in one sample do all chromosomes in a loop#
#run selescan in a loop
for i in $(ls *recode.vcf); do echo $i
       j=`echo $i | sed 's/.recode.vcf/.recode.vcf.map/'`
       $SEL --nsl --maf 0.05 --max-extend 1000000 --max-gap 200000 --cutoff 0.05 --vcf $i --map $j --out $i --threads 20; done

#now yo can do the cross population analysis. This is an example for one chromosomes
$SEL --xpnsl --vcf species1-CHR1.vcf --vcf-ref species2-CHR1.vcf --out species1-species2-CHR1
#
#
#to make all chromosomes in a loop, need one .list file per speices for ech chromosome. The lists need to have the same chromosome order of files. For example species1.list has the chromosomes list of files in the same order as species2.lis.
paste species1.list species2.list |
while read i j
do $SEL --xpnsl --maf 0.05 --max-extend 1000000 --max-gap 200000 --cutoff 0.05 --vcf $i --vcf-ref $j --out minimus_$i --threads 20; done

#Next step, need to normalize all chromosomes together. For this you need to entry each file on the comand line string
# like this example
$NORM --nsl --bp-win --winsize 10000 --bins 100 --files species1-CHR1.nsl.out species1-CHR2.nsl.out species1-CHR3.nsl.out
#The same for the other parameteres that need normalization as well, such as:
$NORM --xpnsl --bp-win --winsize 10000 --bins 100 --files species1-CHR1.nsl.out species1-CHR2.nsl.out species1-CHR3.nsl.out
#
#Finally you will need to run all the chromosomes in a loop in a Slurm Job. See example file Job.Selescan.sh
