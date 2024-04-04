#!/usr/bin/Rscript

# Run the bash script that downloads/parses the feature table from NCBI
system2(command = "./download-ncbi.sh")

# Runs the python scripts that downloads/parses the proteome XML file from Uniprot
system2(command = "./download-uniprot.py")

# Finally, runs the R script that makes the org DB package
source("makeorgdb.R")

# Compresses the resulting package directory
zip(zipfile = "org.Pputida.eg.db.zip", files = "org.Pputida.eg.db")

# Installs the newly created package in your machine
install.packages("./org.Pputida.eg.db/", repos = NULL)
