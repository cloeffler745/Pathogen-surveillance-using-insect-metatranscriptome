#!/bin/bash

#SBATCH --time 1-00:00:00

#SBATCH -p defq

#SBATCH --mail-type=ALL
#SBATCH --mail-user=cmloeffler@gwu.edu

#SBATCH --export=ALL    # Takes the users environment

#SBATCH -o pathoscope_BS_COI_cdhit_%j.out
#SBATCH -e pathoscope_BS_COI_cdhit_%j.err

# set up conda environment
source /GWSPH/home/cmloeffler/miniconda3/etc/profile.d/conda.sh
conda activate pathoscope

# Index the COI references
bowtie2-build -f --threads 38 /scratch/cbi/USDA_aphids/references/Bold_system/test_cdhit /scratch/cbi/USDA_aphids/references/Bold_system/Index/test_cdhit_COI

# make ID_outs folder
mkdir -p /scratch/cbi/USDA_aphids/pathoscope_outs/ID_outs_COI_cdhit/
mkdir -p /scratch/cbi/USDA_aphids/pathoscope_outs/MAP_outs_COI_cdhit/

# Aphids -------------------------------------------------------------------------------------------------

while read line
do 
# Set up pathoscope outputs
mkdir -p /scratch/cbi/USDA_aphids/pathoscope_outs/MAP_outs_COI_cdhit/"$line"_align/"$line-references"/Bold_system/Index

# run pathoscope MAP
pathoscope MAP -1 /scratch/cbi/USDA_aphids/FASTQ/trimmed_paired_lead/"$line"_L001_R1_001.fastq.gz -2 /scratch/cbi/USDA_aphids/FASTQ/trimmed_paired_lead/"$line"_L001_R2_001.fastq.gz \
-indexDir  /scratch/cbi/USDA_aphids \
-numThreads 20 \
-expTag "$line" \
-targetIndexPrefixes references/Bold_system/Index/test_cdhit_COI \
-outDir ../pathoscope_outs/MAP_outs_COI_cdhit/"$line"_align \
-outAlign "$line".sam

# run pathoscope ID
pathoscope ID -alignFile /scratch/cbi/USDA_aphids/pathoscope_outs/MAP_outs_COI_cdhit/"$line"_align/"$line".sam -fileType sam -outDir /scratch/cbi/USDA_aphids/pathoscope_outs/ID_outs_COI_cdhit -expTag "$line"

# Output
echo "Finished $line" 1>&2

done < /scratch/cbi/USDA_aphids/files/sample_list
