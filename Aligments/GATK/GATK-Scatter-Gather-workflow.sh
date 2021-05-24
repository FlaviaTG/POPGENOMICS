###############this is the workflow to use scatter gather approach to call variants with GATK and end up with one VCF file for SNP and indel filtering########
#modules
module load samtools/1.5-fasrc02
##firts you need to have your reference genome index .fai
###obtain reference genome index with samtools
samtools faidx referencegenome.fasta
#also dictionary with picard
java -Xmx80g -XX:ParallelGCThreads=20 -jar $PICPATH CreateSequenceDictionary R=referencegenome.fasta O=Catbic_final.assembly.dict
###creat the list of scaffolds/chromosomes
cut -f1 referencegenome.fasta.fai > referencegenome.list
###divide the lists of scaffolds/chromosomes to run the program on them at the same time to acelerate analyses. You can use split, for example 10 lines, to have 10 chromosomes in 4 list from a total of 40 chromosomes 
split -l 10 --numeric-suffixes referencegenome.list interval_
#now you can run the haplotype calling script on each list of chromosomes per individual.
###SEE THE JOB EXAMPLE haplocall-array-32.SH
###TO RUN THE ARRAY JOB you submit the job calling the array in my 4 lists on one individual for example. If this individual run fine you can make the other Jobs per individual. This way you can have your analyses done in 4 days.
sbatch --array=1-4 Job-GATK-haplo-array_1.sh
####To make many jobs per sample I copy the first JOB that works fine in xx times the number of samples. For example if I have 32 samples and replace on each job the sample number with a small bash code like this:
for i in {1..32}; do cp Job-GATK-haplo-array_1.sh "haplo-array_$i.sh" ; done
#### for example my sample ID ATTTCG in all files will change to CAGCTT in the JOB array haplo-array-10.sh... etc.
grep -rl 'ATTTCG' ./Job-GATK-haplo-array_1.sh | xargs sed -i 's/ATTTCG/CAGCTT/g'
grep -rl 'ATTTCG' ./Job-GATK-haplo-array_2.sh | xargs sed -i 's/ATTTCG/CAGTGT/g'
grep -rl 'ATTTCG' ./Job-GATK-haplo-array_3.sh | xargs sed -i 's/ATTTCG/CCATGT/g'
grep -rl 'ATTTCG' ./Job-GATK-haplo-array_4.sh | xargs sed -i 's/ATTTCG/CGCTAC/g'
#### Now you have your job array per sample and just need to run it them all like this:
for script in haplo-array_*.sh; do sbatch --array=1-4 $script;done
###serial_requeue is working wanderful to run all the scaffolds per sample all together
###When you have all the scaffolds vcf files per sample complated you should get all .idx files per .vcf files. I used this .idx files as control to know that the job finish propertly in that sample.
##Then you will need to join all scaffold per sample in a array again but this time you just need ONE JOB ARRAY WITH ALL YOUR SAMPLES MENTIONED IN THERE. First it will create a database
#### SEE THE JOB ARRAY EXAMPLE Job-GATK-GVCF_database-joint-scaffolds-2.sh
##you will run this job array just one time in all scaffolds like this
sbatch --array=1-4 Job-GATK-GVCF_database-joint-scaffolds-2.sh
###then joint genotyping and produce a multi-sample variant call-set for the databases per scaffold. See the job script: Job-GATK-GVCF-Genotype_scaffold. In general it will take all samples together per chromosomes
~/path/to/gatk GenotypeGVCFs \
--java-options "-Xmx4g -XX:ParallelGCThreads=1" \ 
-R reference.fasta \
-V gendb://GVCF_database \
-O all_samples_interval_1.vcf \
--tmp-dir=/path/to/large/tmp
###finally to get you vcf file you will need to join all the chromosomes in one VFF files withh picard like this:
java -jar ~/path/to/picard.jar GatherVcfs  \
I=all_samples_interval_1.vcf \
I=all_samples_interval_2.vcf \
I=all_samples_interval_3.vcf \
O=all_samples_combined.vcf
##also can be done with GATK, see an example in script: Job-GatherVcf.sh
#now that you have all the samples and chromosomes in one big VCF file you can start filtering your variants. For this see examples of scripts:Job-GATK-SNPs_filter.sh and Job-GATK-all_SNPs
