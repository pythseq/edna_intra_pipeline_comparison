tab <- read.table(Aquarium_2.fasta, header=T)
seqtab_1 <- makeSequenceTable(tab)
seqtab_2 <- removeBimeraDenovo(seqtab_1, verbose=T)
## processes the bimera removal

uniqueSeqs <- getUniques(seqtab_2)
uniquesToFasta(uniqueSeqs, paste0(sample.names, ".fasta")
## creates the new file without bimeras