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

#### 1.build STAR reference STAR ####
```
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
   
   
#### 2. download SRA file and extract paired-end fastq file ####  
if it says "fastq-dump timeout",please try command below to split PE fastq into 2 file.
```
fastq-dump --split-3 /path/to/.sra file/
```

#### 3. align reads to reference STAR ####
```
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



#### output files by now ####
```
        4096 4月  23 14:18 ./
        4096 4月  23 10:44 ../
      373091 4月  23 10:53 chrLength.txt
     1273763 4月  23 10:53 chrNameLength.txt
      900672 4月  23 10:53 chrName.txt
      878884 4月  23 10:53 chrStart.txt
        4096 4月  23 10:46 data/
 20125319168 4月  23 10:58 Genome
         565 4月  23 10:58 genomeParameters.txt
    24080904 6月  22  2018 hervquant_final_reference.fa*
   224880060 6月  23  2018 hervquant_hg19_reference.fa
     6008268 4月  23 10:58 Log.out
  2013500811 4月  23 10:58 SA
      103834 4月  23 10:58 SAindex
  9902790165 4月  23 14:18 testAligned.out.sam
        1846 4月  23 14:18 testLog.final.out
     2620499 4月  23 14:18 testLog.out
         954 4月  23 14:18 testLog.progress.out
      238741 4月  23 14:18 testSJ.out.ta  
```
   
#### 4.filter out all non-herv maps ####
```
$ sed '/uc.*/d' testAligned.out.sam > testAligned.out.filtered.sam
$ samtools view -bS testAligned.out.filtered.sam > testAligned.out.filtered.bam
```

#### assemble reads ####
```
$ salmon quant -t hervquant_final_reference.fa -l ISF -a testAligned.out.filtered.bam -o herv -p 6
Version Info: This is the most recent version of salmon.
# salmon (alignment-based) v0.13.1
# [ program ] => salmon
# [ command ] => quant
# [ targets ] => { hervquant_final_reference.fa }
# [ libType ] => { ISF }
# [ alignments ] => { testAligned.out.filtered.bam }
# [ output ] => { herv }
# [ threads ] => { 6 }
Logs will be written to herv/logs
Library format { type:[2019-04-23 14:41:22.269] [jointLog] [info] Fragment incompatibility prior below threshold.  Incompatible fragments will be ignored.
paired end, relative orientation:inward, strandedness:(sense, antisense) }
[2019-04-23 14:41:22.269] [jointLog] [info] Usage of --useErrorModel implies use of range factorization. rangeFactorization binsis being set to 4
[2019-04-23 14:41:22.269] [jointLog] [info] numQuantThreads = 3
parseThreads = 3
Checking that provided alignment files have consistent headers . . . done
Populating targets from aln = "testAligned.out.filtered.bam", fasta = "hervquant_final_reference.fa" . . .done
[2019-04-23 14:41:22.930] [jointLog] [info] replaced 97,186 non-ACGT nucleotides with random nucleotides

processed 272364 reads in current round
killing thread 2 . . . done

Freeing memory used by read queue . . . 000
Joined parsing thread . . . "testAligned.out.filtered.bam"
Closed all files . . .
Emptied frag queue. . . [2019-04-23 14:41:24.789] [jointLog] [info] Thread saw mini-batch with a maximum of 90.10% zero probability fragments
[2019-04-23 14:41:24.793] [jointLog] [info] Thread saw mini-batch with a maximum of 65.20% zero probability fragments
[2019-04-23 14:41:24.801] [jointLog] [info] Thread saw mini-batch with a maximum of 61.30% zero probability fragments
[2019-04-23 14:41:24.801] [jointLog] [info]


Completed first pass through the alignment file.
Total # of mapped reads : 272364
# of uniquely mapped reads : 221909
# ambiguously mapped reads : 50455

[2019-04-23 14:41:24.831] [jointLog] [info] Computed 14,619 rich equivalence classes for further processing
[2019-04-23 14:41:24.831] [jointLog] [info] Counted 151,138 total reads in the equivalence classes
[2019-04-23 14:41:24.832] [jointLog] [warning] Only 272364 fragments were mapped, but the number of burn-in fragments was set to5000000.
The effective lengths have been computed using the observed mappings.

[2019-04-23 14:41:24.832] [jointLog] [info] starting optimizer
[2019-04-23 14:41:24.834] [jointLog] [info] Marked 0 weighted equivalence classes as degenerate
[2019-04-23 14:41:24.835] [jointLog] [info] iteration = 0 | max rel diff. = 3359.22
[2019-04-23 14:41:24.894] [jointLog] [info] iteration = 100 | max rel diff. = 0.215037
[2019-04-23 14:41:24.898] [jointLog] [info] iteration = 107 | max rel diff. = 0.00100757
[2019-04-23 14:41:24.898] [jointLog] [info] finished optimizer
[2019-04-23 14:41:24.898] [jointLog] [info] writing output

Emptied Alignemnt Group Pool. .
Emptied Alignment Group Queue. . . done  
```

#### DONE! ####


