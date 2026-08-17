#!/bin/bash

#SBATCH --time 4-00:00:00

#SBATCH -p defq

#SBATCH --mail-type=ALL
#SBATCH --mail-user=cmloeffler@gwu.edu

#SBATCH --export=ALL    # Takes the users environment

#SBATCH -o trim_last_%j.out
#SBATCH -e trim_last_%j.err

source /GWSPH/home/cmloeffler/miniconda3/etc/profile.d/conda.sh

mkdir -p ../FASTQ/trimmed_paired_lead
mkdir -p ../FASTQ/trimmed_unpaired_lead

conda activate trimmomatic

# Sliding window included
while read line
do
        trimmomatic PE ../FASTQ/$line"_L001_R1_001.fastq.gz" ../FASTQ/$line"_L001_R2_001.fastq.gz" ../FASTQ/trimmed_paired_lead/$line"_L001_R1_001.fastq.gz" ../FASTQ/trimmed_unpaired_lead/$line"_L001_R1_001.fastq.gz" ../FASTQ/trimmed_paired_lead/$line"_L001_R2_001.fastq.gz" ../FASTQ/trimmed_unpaired_lead/$line"_L001_R2_001.fastq.gz" AVGQUAL:3 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:15 MINLEN:5
        echo "Finished $line"
done < ../files/sample_list

# QC the trimmed and paired reads
conda deactivate
conda activate fastQC

mkdir -p ../QC/fastQCResults_trim_lead

fastqc -t 6 ../FASTQ/trimmed_paired_lead/* -o ../QC/fastQCResults_trim_lead

conda deactivate
conda activate multiQC

multiqc ../QC/fastQCResults_trim_lead --interactive -o ../QC/ -n multiqc_trim_lead

echo "QC finished"

