#STEP 1 : Be prepared

## load the package :
library("dada2")

## create a path to your ".fastq" files :
path <- "./edna_intra_pipeline_comparison/samples"

## select the ".fastq" files you want to analyze :
fns <- sort(list.files(path, pattern = ".fastq", full.names = T))

## the function only extracts files that end with the chosen pattern and
## they are extracted with their whole path

## then you can only keep the part of your files name you want :
sample.names <- sapply(strsplit(basename(fns), ".fastq"), '[', 1)

## the function "basename" removes all the path up to the file name

## the function "strsplit" removes the pattern written

########################################################################
#STEP 2 : Filtering & Trimming

## begin the creation of the new files and folder :
filts <- file.path(path, "filtered", paste0(sample.names, ".filt.fastq.gz"))

## builds the path to the new folder, which will be located in the path
## already used and which name will be "filtered"

## the files are named as described before with "sample.names", and
## the pattern ".filt.fastq.gz" will be added

## from the ".fastq files" of "fns", create the new ".fastq" files of
## "filts" after filtering and trimming :
out <- filterAndTrim(fns, filts,
                     truncLen = 235,
                     maxN = 0,
                     maxEE = 1,
                     compress = T,
                     verbose = T)

## "truncLen" value is chosen considering the marker length and define
## were the reads will be trimmed (after 235 bp here), and reads which
## are shortened than this value are filtered

## "maxN" is the number of N tolerated in the sequences after
## filtering (0 here)

## "maxEE" defines the maximal number of expected errors tolerated in a
## read (1 here), based on the quality score (EE = sum(10^(-Q/10)))

## "compress = T" means that the files will be gzipped

## "verbose = T" means that information concerning the number of sequences after
## sequences after filtering will be given

########################################################################
#STEP 3 : Dereplication

## "derepFastq" function eliminates all the replications of each sequence in the files
derep <- derepFastq(filts)

## the function annotates each sequence with his abundance

########################################################################
#STEP 3 : Processing step

## these functions permit to generate ASVs from the data thanks to an
## error estimation model based on the data :

err <- learnErrors(derep[k], randomize=T)
## builds the error model
dadas <- dada(derep[k], err)
## eliminates the false sequences identified by the model to oncly 
## conserve ASVs
seqtab <- makeSequenceTable(dadas)
## constructs a sequence table with the sequences filtered
uniqueSeqs <- getUniques(seqtab)
uniquesToFasta(uniqueSeqs, paste0("PipelineB_", sample.names[k], ".fasta"))
## creates a new ".fasta" file constaining the ASVs