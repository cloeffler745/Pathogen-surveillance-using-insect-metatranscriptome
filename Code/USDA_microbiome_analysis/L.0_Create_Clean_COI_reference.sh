#!/bin/bash

# Link the conda environment and activate the packages
source /GWSPH/home/cmloeffler/miniconda3/etc/profile.d/conda.sh
conda activate subset_reads

# Combine all the Bold System references and remove duplicates with rmdup
cat ../references/Bold_system/BS_Hemi_COX1.fas ../references/Bold_system/BS_Hymen_COX1.fas ../references/Bold_system/BS_ants_COX1.fas ../references/Bold_system/BS_aphid_COX1.fas ../references/Bold_system/Hemi_Hymen_COI.fas | seqkit rmdup -s > ../references/Bold_system/BS_all_rmdup.fasta

# Select only the COI references
grep ">" ../references/Bold_system/BS_all_rmdup.fasta | grep "COI" | sed 's/>//g' > these.txt
seqtk subseq ../references/Bold_system/BS_all_rmdup.fasta these.txt > ../references/Bold_system/BS_all_rmdup_COIonly.fasta
rm these.txt

# Select only the species COIs (spaces only exist in the species/strain level references)
grep ">" ../references/Bold_system/BS_all_rmdup_COIonly.fasta | grep " " | sed 's/>//g' > hold.txt
seqtk subseq ../references/Bold_system/BS_all_rmdup_COIonly.fasta hold.txt > ../references/Bold_system/BS_all_rmdup_COIonly_speciesOnly.fasta
rm hold.txt

# The spaces mess everything up in the output, replace them with "_" 
sed "s/ /_/g" ../references/Bold_system/BS_all_rmdup_COIonly_speciesOnly.fasta > ../references/Bold_system/BS_all_rmdup_COIonly_speciesOnly_NOSPACES.fasta

# CD-hit to remove the other references
module load cd-hit/4.8.1
cd-hit-est -i ../references/Bold_system/BS_all_rmdup_COIonly_speciesOnly_NOSPACES.fasta -o ../references/Bold_system/test_cdhit -c 0.95 -n 8 > ../references/Bold_system/cd_log.txt
