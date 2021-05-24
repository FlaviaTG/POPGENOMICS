library(tidyverse)
library(magrittr)
library(dplyr)
library(ggplot2)
#
tbl=read.table("Climacteris-29ind.THIN10kb.recode.vcf.2.Q")
###ordering bars
indTable=read.table("id-ADMIX-climacteris.txt", header=T)
mergedAdmixtureTable = cbind(tbl, indTable)
#order by species and locality
ordered = mergedAdmixtureTable[order(mergedAdmixtureTable$sp,mergedAdmixtureTable$loc),]
png("ADMIX-barplot-Climacteris-K2.png")
par(mar=c(9,5,1,1)+.1)
barplot(t(as.matrix(ordered[, 1:2])), col = c("#E69F00","#999999","darkorange4"), names=ordered$ID, 
        ylab="Ancestry",
        font.lab=1.5, 
        cex.lab=1.5, las=2, cex.names=0.8)
dev.off()
##
#
#cross validation of K
##
grep -h CV Bootlog*.out > cross.val.txt
###edit spaces in this file with nano and plot on R
library(ggplot2)
C <- read.table("cross.val.txt")
C[order(C$V1),]
p <- ggplot(C, aes(x = V1, y=V2)) + geom_point(stat = "identity",position = "dodge") + geom_line() + scale_y_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10)) + labs(x = "K", y="error") + theme_bw() +
  theme(axis.line = element_line(colour = "black"), text = element_text(size=14),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank()) 
ggsave("ADMIX-cross-val-climacteris.png", plot=p, width=30, height=15, dpi=300)
