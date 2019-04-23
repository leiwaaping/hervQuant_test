# hervQuant_test

## Notices ! All this data were from paper ***Endogenous retroviral signatures predict immunotherapy response in clear cell renal cell carcinoma*** https://www.jci.org/articles/view/121476 This article is for reference only ##



>The role of human endogenous retroviruses in tumor immunomodulation
Human endogenous retroviruses (hERVs) are remnants of exogenous retroviruses that have integrated into the genome over the course of human evolution. We developed a novel workflow, hervQuant, which identified over 3,000 transcriptionally active hERVs within The Cancer Genome Atlas (TCGA) pan-cancer RNA-seq database. The hervQuant workflow is able to identify individual, full length hERVs from short read RNA-seq data. Both the workflow as well as TCGA hERV quantification are publicly available for academic usage; all other users are requested to contact Dr. Benjamin Vincent.



### software & reference ###
- STAR v2.5.3a (https://github.com/alexdobin/STAR/archive/2.5.3a.tar.gz) 
- Salmon v0.8.2 (https://github.com/COMBINE-lab/salmon/archive/v0.8.2.tar.gz) 
- Samtools v1.4 (https://github.com/samtools/samtools/releases/download/1.4/samtools-1.4.tar.bz2) 
- RV reference sequences adapted from Vargiu, L. et al. (2016). 
- rvQuant reference with transcriptome (“hervquant_hg19_reference.fa”,download from https://unclineberger.org/files/2018/12/hervquant_hg19_reference.fa_.zip) 
- rvQuant reference (“hervquant_final_reference.fa”,attached)

STAR ,samtools and Salmon also can install by conda,Environment configuration process is omitted，please see ***INSTRUCTION***

### STAR ###

```
# 1.build STAR reference STAR
$ STAR --runMode genomeGenerate --runThreadN 6 --limitGenomeGenerateRAM 53667544448 --genomeSAindexNbases 7 --genomeDir . --genomeFastaFiles hervquant_hg19_reference.fa
Apr 23 10:53:05 ..... started STAR run
Apr 23 10:53:05 ... starting to generate Genome files
Apr 23 10:54:17 ... starting to sort Suffix Array. This may take a long time...
Apr 23 10:55:33 ... sorting Suffix Array chunks and saving them to disk...
Apr 23 10:58:00 ... loading chunks from disk, packing SA...
Apr 23 10:58:37 ... finished generating suffix array
Apr 23 10:58:37 ... generating Suffix Array index
Apr 23 10:58:37 ... completed Suffix Array index
Apr 23 10:58:37 ... writing Genome to disk ...
Apr 23 10:58:51 ... writing Suffix Array to disk ...
Apr 23 10:58:52 ... writing SAindex to disk
Apr 23 10:58:52 ..... finished successfully
```
 --runMode selsct running mode  
 --runThreadN how many CPU you want to use  
 --limitGenomeGenerateRAM ? normally it will remind you which number you should set if your parameter is too small  
 --genomeDir  dictionary with reference files  
 --genomeFastaFiles reference file  
   
   
2. download SRA file and extract paired-end fastq file  
if it says "fastq-dump timeout",please try command below to split PE fastq into 2 file.
```
fastq-dump --split-3 /path/to/.sra file/
```

```
# 3. #align reads to reference STAR
$ STAR --runThreadN 6 --outFileNamePrefix test --outFilterMultimapNmax 10 --outFilterMismatchNmax 7 --genomeDir . --readFilesIn /path/to/SRR2989969_1.fastq /path/to/SRR2989969_2.fastq
Apr 23 14:11:05 ..... started STAR run
Apr 23 14:11:05 ..... loading genome
Apr 23 14:11:16 ..... started mapping
Apr 23 14:18:23 ..... finished mapping
Apr 23 14:18:24 ..... finished successfully
```
  --outFileNamePrefix    output prefix  
  --outFilterMultimapNmax    最多允许一个reads被匹配到多少个地方  
  --outFilterMismatchNmax    过滤掉每个paired read mismatch数目超过N的数据，999代表着忽略这个过滤  
  --readFilesIn    input fastq files  


  
   
