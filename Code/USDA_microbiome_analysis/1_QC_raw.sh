#!/bin/bash

#SBATCH --time 1:00:00

#SBATCH -p debug

#SBATCH --mail-type=ALL
#SBATCH --mail-user=cmloeffler@gwu.edu

#SBATCH --export=ALL    # Takes the users environment

#SBATCH -o QC_raw_%j.out
#SBATCH -e QC_raw_%j.err

mkdir -p ../QC/fastQCResults_raw

source /GWSPH/home/cmloeffler/miniconda3/etc/profile.d/conda.sh

conda activate fastQC
fastqc -t 6 ../FASTQ/*.fastq.gz -o ../QC/fastQCResults_raw

conda activate multiQC
multiqc ../QC/fastQCResults_raw --interactive -o ../QC -n multiqc_raw

echo "DONE"
