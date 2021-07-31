library("lulu")

OTUtable <- read.fasta(Aquarium_2.clustered.fasta)
matchlist <- read.table(match_list_Aquarium_2.txt)
## prepare the files needed for LULU processing

curated_results <- lulu(OTUtable, matchlist)
## LULU processing with the lulu R function

curated_results
## shows the OTU names and their abundance after the curation
