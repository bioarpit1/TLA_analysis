#$ -S /bin/bash
ids=(
CL21_S1
CL22_S2
CL23_S3
CL24_S4
CL25_S5
CL26_S6
CL27_S7
CL28_S8
CL29_S9
CL30_S10
CL31_S11
CL32_S12
CL33_S13
CL34_S14
CL35_S15
CL36_S16
CL37_S17
CL38_S18
CL39_S19
CL42_S20
CL43_S21
CL44_S22)

for i in ${ids[@]}; do
        qsub -cwd -v file=${i} -N pairedtrim_${i} pairedtrim.sh 
done
