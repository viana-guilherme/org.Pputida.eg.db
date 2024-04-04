#!  /usr/bin/env bash

# This script automatically downloads the necessary file to create the GO term
# package from the NCBI ftp database and processes it for the subsequent steps in R

# signals the script has started running
echo "Connecting to NCBI..."

# creating the output directory
mkdir -p resources

# this link is hardcoded - maybe upgrade to a more flexible option in the future?
baseUrl="https://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/Pseudomonas_putida/all_assembly_versions/GCA_000007565.2_ASM756v2/"
filename="GCA_000007565.2_ASM756v2_feature_table.txt.gz"

# downloads the feature table file
echo "downloading ${filename}"
curl -LO "${baseUrl}${filename}"
gzip -dk ${filename}

# Takes the uncompressed file to subset the information needed for the construction of the Org.db package
featuresFile=${filename%???} # removes the final three characters of the filename string (.gz)

# retrieving the relevant information in the feature table and save it as TSVs
awk -F'\t' '$1 ~ "CDS" {print $17 "\t" $15 "\t" $14}' ${featuresFile} > fSym.tsv # gene symbols
awk -F'\t' '$1 ~ "CDS" {print $17 "\t" $6}' ${featuresFile} > fChr.tsv # chromossome

# moves the newly downloaded/created files to the "resources" directory
mv fChr.tsv fSym.tsv "${featuresFile}" "${featuresFile}.gz" resources

# signals the script has finished running
echo "Finished downloading and processing the feature table!"
