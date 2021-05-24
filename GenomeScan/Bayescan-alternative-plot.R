#bring the SNP list from the vcf file used on bayescan run
bcftools query -f '%CHROM %POS\n' newH-genolike_28_minimus-ZCHR-noFEM-PHASED-10kb-bayescan.recode.vcf > bayescan-ZCHR-SNPlist.txt
#
library(ggplot2)
bayescan=read.table("bayescan-output_fst.txt")
plot_bayescan(bayescan,FDR=0.05)
#
SNPb=read.table("bayescan-ZCHR-SNPlist.txt",header=F)
bayescan=cbind(SNPb, bayescan)
colnames(bayescan)=c("SNP","POST_PROB","LOG10_PO","Q_VALUE","ALPHA","FST")
#
POST_PROB = 0.99 & Q_VALUE = 0 == 0.0001 
attach(bayescan)
class(bayescan$Q_VALUE)
#
bayescan$Q_VALUE <- as.numeric(bayescan$Q_VALUE)
bayescan[bayescan$Q_VALUE<=0.0001,"Q_VALUE"]=0.0001
bayescan$POST_PROB <- (round(bayescan$POST_PROB, 4))
bayescan$LOG10_PO <- (round(bayescan$LOG10_PO, 4))
bayescan$Q_VALUE <- (round(bayescan$Q_VALUE, 4))
bayescan$ALPHA <- (round(bayescan$ALPHA, 4))
bayescan$FST <- (round(bayescan$FST, 6))
#
bayescan$SELECTION <- ifelse(bayescan$ALPHA>=0&bayescan$Q_VALUE<=0.05,"diversifying",ifelse(bayescan$ALPHA<=0&bayescan$Q_VALUE<=0.05,"balancing","neutral"))
bayescan$SELECTION<- factor(bayescan$SELECTION)
levels(bayescan$SELECTION)
bayescan$SELECTION<- factor(bayescan$SELECTION)
levels(bayescan$SELECTION)


#
positive <- bayescan[bayescan$SELECTION=="diversifying",]
neutral <- bayescan[bayescan$SELECTION=="neutral",]
balancing <- bayescan[bayescan$SELECTION=="balancing",]
xtabs(data=bayescan, ~SELECTION)
#
write.table(neutral, "neutral_snps-odd5.txt", row.names=F, quote=F)
write.table(balancing, "balancing_snps-odd5.txt", row.names=F, quote=F)
write.table(positive, "positive_snps-odd5.txt", row.names=F, quote=F)
#
bayescan$LOG10_Q <- log10(bayescan$Q_VALUE)
#
bayescan[["SELECTION"]] <- factor(bayescan[["SELECTION"]],levels=c("diversifying","neutral","balancing"), ordered=T)
levels(bayescan$SELECTION)
xtabs(data=bayescan, ~SELECTION)
#
x_title="Log10(Q_VALUE)"
y_title="Fst"
posi=length(positive$SELECTION)
neut=length(neutral$SELECTION)
graph_1<-ggplot(bayescan,aes(x=LOG10_Q,y=FST))
graph_1+geom_point(aes(colour=bayescan$SELECTION))+
   scale_colour_manual(name="Selection",values=c("red","black"))+
   labs(x=x_title)+
   labs(y=y_title)+
   geom_vline(xintercept=c(log10(0.05)),color="black")+
theme(axis.line = element_line(colour = "black"),
axis.text.x = element_text(size = 14, angle = 0, hjust = 1, vjust = 0, face = "plain"),
axis.text.y = element_text(size = 14, angle = 0, hjust = 1, vjust = 0, face = "plain"), 
axis.title=element_text(size=20,face="bold"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank()) + theme(legend.position="none")
ggsave("bayescan_ZCH-catharus-odd5.png")
png("bayescan_ZCH-catharus-odd5-fdr0.05.png")
