#$ -S /bin/bash
#$ -l mfree=10G -l h_rt=100:00:00
#$ -pe serial 1-5
#$ -R y
cd /net/hawkins/vol1/arpit/sratoolkitout/sra/fastq/TLA_data_lieberlab/newdata_18thsep2018/trimmeddata


bwa bwasw -b 7 /net/hawkins/vol1/scripts_files/mm10/mm10_bwa_index/mm10bwaidx ${file}.fq.gz > ${file}.sam
samtools view -bS ${file}.sam > ${file}_nonSorted.bam
samtools sort -O bam -o ${file}_sorted.bam -T {file}_temp ${file}_nonSorted.bam
samtools index ${file}_sorted.bam
