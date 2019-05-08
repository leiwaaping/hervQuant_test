#! /bin/bash

#bam to fastq
path=~/../../data/bam
#ls $path/ |grep -v '.txt'|grep -v 'FASTQ' > file.list &&
echo $path
for sra in `cat file.list`
do
#see if complete before:
  if [ -d "$sra" ];then
    echo "$sra done already!"
    continue
  fi

  mkdir $sra 
  #echo $path &&
  #echo $bam &&
  #fastq-dump -O ${path} --split-3 ${path}/${sra}.sra &&
  #fq1=`ls *_1.fastq`
  #fq2=`ls *_2.fastq` 

  #single-end
  #STAR --runThreadN 20 --outFileNamePrefix tmp --outFilterMultimapNmax 10 --outFilterMismatchNmax 7 --genomeDir ref/ --readFilesIn ${path}/${sra}.fastq &&
  #paired-end
  STAR --runThreadN 20 --outFileNamePrefix tmp --outFilterMultimapScoreRange 4000 --outFilterMultimapNmax 10 --outFilterMismatchNmax 7 --genomeDir ref/ --readFilesIn ${path}/${sra}_1.fastq ${path}/${sra}_2.fastq &&

  sed '/uc.*/d' tmpAligned.out.sam > tmpAligned.out.filtered.sam &&
  samtools view -bS tmpAligned.out.filtered.sam > $sra/Aligned.out.filtered.bam &&

  salmon quant -t ref/hervquant_final_reference.fa -l ISF -a $sra/Aligned.out.filtered.bam -o $sra -p 20 &&
  if [ -e "$sra/quant.sf" ];then
    #rm *.sam
    rm *.out.*
    rm *.out
    #mv *.fastq $path/
  else
    echo "error in $sra！\n"
  fi
done

rm *.sam
