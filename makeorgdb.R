# After downloading the data and preparing it using the
# scripts provided elsewhere in the repo,
# We are able to create the package

## prepare some data frames
fSym <- read.delim("resources/fSym.tsv", sep = "\t", header = FALSE)
colnames(fSym) <- c("GID","SYMBOL","GENENAME")

fChr <- read.delim("resources/fChr.tsv", sep = "\t", header = FALSE)
colnames(fChr) <- c("GID","CHROMOSOME")
fChr$CHROMOSOME <- 1 # we only have one chromossome

fGO <- read.delim("resources/fGO.tsv", sep = "\t", header = TRUE)

## Then call the function
AnnotationForge::makeOrgPackage(gene_info = fSym,
               chromosome = fChr,
               go = fGO,
               version = "0.1",
               maintainer = "Guilherme Viana <viana.guilherme@proton.me>",
               author = "Guilherme Viana <viana.guilherme@proton.me>",
               outputDir = ".",
               tax_id = "160488",
               genus = "Pseudomonas",
               species = "putida",
               goTable = "go")

## then you can call install.packages based on the return value
#install.packages("./org.Pputida.eg.db/", repos = NULL)
