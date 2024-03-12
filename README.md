# Making a GO terms data package for _Pseudomonas putida_

I've been working with _P. putida_ in my doctorate, and I noticed that there wasn't a proper GO term annotation package for this organism in Bioconductor that I could use for the enrichment analyses I had been trying to perform with `clusterProfiler`.

After trying some alternatives, I've decided to build one myself following the steps provided in `AnnotationForge::makeOrgPackage()` vignette. This repository contains all the code necessary to build this package from scratch if needed - or it can also be tweaked for building similar packages for other organisms that have data available in NCBI/Uniprot but no R annotation package available for them.

This workflow has been tested in a machine running Pop! OS 22.04, using bash 5.1.16, Python 3.8.12 and R version 4.3.2 (with annotationForge version 1.42.2). The source code for the final annotation package is also available for those who prefer to skip the building step and focus on getting their analyses up and running (see TL;DR at the bottom of this document).

## Usage

There are three parts to the workflow contained in this repository:

1. Obtaining the table with genomic features for _P. putida_ found in NCBI's FTP server. This is done by the `download-ncbi.sh` script

2. Obtaining all GO term annotations for each _putida_ gene (where they are present). This is done by the `download-uniprot.py` script.

3. Finally, assembling all of the previous information and generating the annotation package with `AnnotationForge::makeOrgPackage()`. This is done by the `makeorgdb.R` script.

Working with different programming languages and so many libraries means that this workflow is bound to break at some point. I have tried to write all scripts using as many built-in functions as possible, but I apologize if in the future things do not run smoothly. Please, feel free to reach out should you run in any issue!

For convenience, I have included a `run-workflow.R` script that automatically runs every script in this repository and auto-installs the annotation package at the end. The source code of the package can also be downloaded from this repository for manual installation.

> **TL;DR:**
> Download the source code for the package and extract it. Navigate to that directory in R and run `install.packages("./org.Pputida.eg.db/", repos = NULL)` to install the package and make it available for your bioconductor workflows
