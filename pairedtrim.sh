#$ -S /bin/bash
#$ -l mfree=50G -l h_rt=100:00:00
#$ -pe serial 1-4	

cd /net/hawkins/vol1/arpit/sratoolkitout/sra/fastq/TLA_data_lieberlab/newdata_18thsep2018 

trim_galore --trim1 --phred33 --fastqc --output_dir trimmeddata --paired ${file}_R1_001.fastq.gz ${file}_R2_001.fastq.gz

