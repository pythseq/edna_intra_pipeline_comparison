# eDNA_intra_pipeline_comparison

**Bastien Macé, 2021**

_________________________________


# Table of contents

  * [I - Introduction](#intro)
  * [II - Installation](#install)
    + [Preliminary steps for OBITools](#preliminary-steps-for-obitools)
    + [Preliminary steps for DADA2](#preliminary-steps-for-dada2)
    + [Preliminary steps for SWARM](#preliminary-steps-for-swarm)
    + [Preliminary steps for LULU](#preliminary-steps-for-lulu)
    + [Preliminary steps for VSEARCH](#preliminary-steps-for-vsearch)
  * [III - Pre-processing steps](#step1)
  * [IV - Key processing steps](#step2)
    + [IV - 1 - OBITOOLS processing step (Pipelines A)](#step21)
    + [IV - 2 - DADA2 processing step (Pipelines B)](#step22)
    + [IV - 3 - SWARM processing step (Pipelines C)](#step23)
    + [IV - 4 - SWARM + LULU processing step (Pipelines D)](#step24)
  * [V - Abundance filtering step](#step3)  
  * [VI - Post-processing steps](#step4)
    + [VI - 1 - No post-processing step (Pipelines A1/B1/C1/D1)](#step41)
    + [VI - 2 - Bimeric sequences removal (Pipelines A2/B2/C2/D2)](#step42)
    + [VI - 3 - Chimeric sequences removal (Pipelines A3/B3/C3/D3)](#step43)
  * [VII - Analyse your results](#step5)

_________________________________

<a name="intro"></a>
## I - Introduction

This project aims to compare twelve bioinformatics pipelines based on five existing metabarcoding programs to make recommendations for data management in intraspecific variability studies using environmental DNA.

Data processing is necessary in metabarcoding studies to eliminate false sequences which are generated during amplification and sequencing, and particularly for intraspecific studies from eDNA samples, where the presence of false sequences in the data can over-estimate the intraspecific genetic variability.
That is why there is a need in filtering sequences with bioinformatics pipelines. Different bioinformatics tools have been developped for metabarcoding studies. Here, we propose to compare some of them, by building twelve unique pipelines.

For that, we use the following programs :

- [OBITOOLS](https://git.metabarcoding.org/obitools/obitools/wikis/home) : a set of commands written in python
- [DADA2](https://benjjneb.github.io/dada2/index.html) : a R package
- [SWARM](https://github.com/torognes/swarm) : a command written in C++
- [LULU](https://github.com/tobiasgf/lulu) : a R package
- [VSEARCH](https://github.com/torognes/vsearch) : a set of commands written in C++

The following figure summarizes the twelve pipelines compared in our study :

![Figure](Figure.jpg)

In our study, we analyze the results of a paired-end sequencing, after extraction and amplification of filtrated eDNA from aquarium seawater, to detect intraspecific haplotypic variability in *Mullus surmuletus*. Only one aquarium is given as example in the scripts.

The following scripts were used for the bioinformatics analysis of [this publication](https://doi.org/10.1002/edn3.269), based on the datasets available [here](https://zenodo.org/record/4570303). 

<a name="install"></a>
## II - Installation

### Preliminary steps for OBITools

You need to have Anaconda installed. If it's not the case, click on this [link](https://www.anaconda.com/products/individual/get-started) and download it. Install the download in your shell, close your shell and reopen it.

Verify conda is correctly installed. It should be here :
```
~/anaconda3/bin/conda
```

Write the following line :
```
conda config --set auto_activate_base false
```

Then, create your new environment obitools from your root in your corresponding path. For example :
```
ENVYAML=./dada2_and_obitools/obitools_env_conda.yaml
conda env create -f $ENVYAML
```

Now you can activate your environment before starting OBITOOLS commands :
```
conda activate obitools
```

And deactivate it :
```
conda deactivate
```
### Preliminary steps for DADA2

You need to have a recent R version (3.6.2 minimum). If it's not the case, click on this [link](https://cran.r-project.org/) and download it.

Then, open your IDE (RStudio for example), and install the package :
```
install.packages("dada2")
```

### Preliminary steps for SWARM

Get the compressed folder on the [creator GitHub](https://github.com/torognes/swarm) in your downloads folder and install it :
```
git clone https://github.com/torognes/swarm.git
cd swarm/
make
```

### Preliminary steps for LULU

Open your IDE for R (RStudio for example), and install the package :
```
install.packages("lulu")
```

### Preliminary steps for VSEARCH

Get the compressed folder on the [creator GitHub](https://github.com/torognes/vsearch) in your downloads folder and install it :
```
git clone https://github.com/torognes/vsearch.git
cd vsearch
./autogen.sh
./configure
make
sudo make install
```

<a name="step1"></a>
## III - Pre-processing steps

### Merging paired-end sequenced reads (OBITOOLS)

Activate your environment for OBITOOLS in your shell :
```
conda activate obitools
```

Use the command _illuminapairedend_ to make the paired-end merging from the forward and reverse strands of the sequences you have in your data. The command aligns the complementary strands in order to get a longer sequence. In fact, after PCR, the last bases are rarely correctly sequenced. So having the forward and the reverse strands allows to lenghten the sequence, thanks to the beginning of the reverse strand, which is usually correctly sequenced.
```
illuminapairedend --score-min=40 -r mullus_surmuletus_data/Aquarium_2_F.fastq mullus_surmuletus_data/Aquarium_2_R.fastq > Aquarium_2.fastq
# a new .fastq file is created, it contains the sequences after the merging of forward and reverse strands
# alignments which have a quality score higher than 40 (-- score-min=40) are merged and annotated "aligned", while alignemnts with a lower quality score are concatenated and annotated "joined"
```

To only conserve the sequences which have been merged, use _obigrep_ :
```
obigrep -p 'mode!="joined"' Aquarium_2.fastq > Aquarium_2.ali.fastq
# -p requires a python expression
# python creates a new dataset (.ali.fastq) which only contains the sequences annotated "aligned"
```

### Demultiplexing (OBITOOLS)

A _.txt_ file assigns each sequence to its sample thanks to its tag, because each tag corresponds to a reverse or a forward sequence from a sample.

To compare the sequences next, you need to remove the tags and the primers, by using the _ngsfilter_ command :
```
ngsfilter -t mullus_surmuletus_data/Med_corr_tags.txt -u Aquarium_2.unidentified.fastq Aquarium_2.ali.fastq > Aquarium_2.ali.assigned.fastq
# the command creates new files :
# ".unidentified.fastq" file contains the sequences that were not assigned whith a correct tag
# ".ali.assigned.fastq" file contains the sequences that were assigned with a correct tag, so they contain only the barcode sequences
```

Then, separate your _.ali.assigned.fastq_ files depending on their samples in placing them in a dedicated folder (useful for next steps) :
```
mkdir samples
# creates the folder
mv -t samples Aquarium_2.ali.assigned.fastq
# places the latests ".fastq" files in the folder
cd samples
obisplit -t samples --fastq sample/Aquarium_2.ali.assigned.fastq
# separates the files depending on their samples
mv -t ./dada2_and_obitools Aquarium_2.ali.assigned.fastq
# removes the original files from the folder
```

Now you have as many files as samples, containing demultiplexed sequences.

### Be prepared for DADA2

Quit your shell and open your IDE for R.

First you have to load the dada2 package :
```
library("dada2")
```

Select the files you want to analyze in your path containing your demultiplexed data :
```
fns <- sort(list.files(path, pattern = ".fastq"", full.names = T))
# the function only extracts files that end with the chosen pattern and they are extracted with their whole path
```

And select the part of the files name you want to keep :
```
sample.names <- sapply(strsplit(basename(fns), ".fastq"), '[', 1)
# the function "basename" removes all the path up to the file name
# the function "strsplit" removes the pattern written
```

### Filtering & Trimming (DADA2)

Initiate the creation of a new folder to store the filtered sequences generated :
```
filts <- file.path(path, "filtered", paste0(sample.names, ".filt.fastq.gz"))
# builds the path to the new folder, which will be located in the path already used and which name will be "filtered"
# the files are named as described before with sample.names, and the pattern ".filt.fastq.gz" will be added
```

These files are created after trimming and filtering with different criteria :
```
out <- filterAndTrim(fns, filts,
                     truncLen = 235,
                     maxN = 0,
                     maxEE = 1,
                     compress = T,
                     verbose = T)
# "truncLen" value is chosen considering the marker length and define were the reads will be trimmed (after 235 bp here), and reads which are shortened than this value are filtered
# "maxN" is the number of N tolerated in the sequences after filtering (0 here)
# "maxEE" define the maximal number of expected errors tolerated in a read (1 here), based on the quality score (EE = sum(10^(-Q/10)))
# "compress = T" means that the files will be gzipped
# "verbose = T" means that information concerning the number of sequences after filtering will be given
```

The filtering permits to clean the data to eliminate a large number of unexploitable sequences for our study, and the trimming permits to facilitate the sequence comparison in the next steps.

### Dereplication (DADA2)

Now you can eliminate all the replications of each sequence from the new _.fastq.gz_ files :
```
derep <- derepFastq(filts)
# the function annotates each sequence with his abundance
```

This dereplication will considerably reduce the processing time of the next steps, and no information is lost as the abundance (or read count) of each sequence is now annotated in its header.

<a name="step2"></a>
## IV - Key processing steps

<a name="step21"></a>
### IV - 1 - OBITOOLS processing step (Pipelines A)

The OBITOOLS command used in pipelines A is _obiclean_. This command eliminates punctual errors caused during PCR. The algorithm makes parwise alignments for all the amplicons. It counts the number of dissimilarities between the  amplicons, and calculates the ratio between the abundance of the two amplicons aligned. If there is only 1 dissimilarity (parameter by default, can be modified by the user) and if the ratio is lower than a threshold set by the user, the less abundant amplicon is considered as a variant of the most abundant one.

Sequences which are at the origin of variants without being considered as one are tagged "head". The variants are tagged "internal". The other sequences are tagged "singleton".

By only conserving the sequences tagged "head", most of erroneous sequences are eliminated.

The following line is lanched in a shell, after the R pre-processing steps :
```
obiclean -r 0.05 -H Aquarium_2.fasta > Aquarium_2.clean.fasta
# here, the command only returns only the sequences tagged "head" by the algorithm, and the chosen ratio is 0.05
```

For more details on this OBITOOLS processing step, see the original publication [here](https://doi.org/10.1111/1755-0998.12428).

<a name="step22"></a>
### IV - 2 - DADA2 processing step (Pipelines B)

The DADA2 function used in pipelines B is _learnErrors_. This function is able to distinguish the incorrect sequences from the correct sequences generated during amplification and sequencing, by estimating the sequencing error rate.

To build the error model, the function alternates estimation of the error rate and inference of sample composition until they converge on a jointly consistent solution.

The algorithm calculates the abundance p-value for each sequence. This p-value is defined by a Poisson distribution, with a parameter correspondig to the rate of amplicons of a sequence i generated from a sequence j.

Before that, a partition is built with the most abundant sequence as the core. All the other sequences are compared to this core. The sequence with the smallest p-value is analyzed : if this p-value is inferior than a parameter of the algorithm (OMEGA_A), this sequence become the core of a new partition. The other sequences joins the partition most likely to have produced the core. This operation is repeated until there is no p-value which falls under the parameter OMEGA_A.

Then, all the sequences from a partition are transformed into their core, so each partition corresponds to a unique sequence : the ASV (Amplicon sequence variant).

The following lines are lanched in R following the R pre-processing steps :
```
err <- learnErrors(derep[k], randomize=T)
# builds the error model
dadas <- dada(derep[k], err)
# eliminates the false sequences identified by the model to oncly conserve ASVs
seqtab <- makeSequenceTable(dadas)
# constructs a sequence table with the sequences filtered
uniqueSeqs <- getUniques(seqtab)
uniquesToFasta(uniqueSeqs, paste0("PipelineB_", sample.names[k], ".fasta"))
# creates a new ".fasta" file constaining the ASVs
```

For more details on this DADA2 processing step, see the original publication [here](https://doi.org/10.1038/nmeth.3869).

<a name="step23"></a>
### IV - 3 - SWARM processing step (Pipelines C)

In pipelines C, SWARM gathers the sequences in OTUs (Operational taxonomic units). First, sequences are pairwise aligned to count the number of dissimilarities between them. A threshold _d_ is chosen by the user, and when the number of dissimilarities is inferior or equal to _d_, both sequences are gathered in a same OTU. This process is then repeated to add iteratively each sequences to an OTU, and the most abundant sequence of each OTU is chosen to represent the OTU. The abundance of the OTU is constituted by adding the abundances of each sequence included in the OTU

The following line process the algorithm :
```
swarm -z -d 1 -o stats_Aquarium_2.txt -w Aquarium_2.clustered.fasta < Aquarium_2.fasta
# "-z" option permits to accept the abundance in the header, provided that there is no space in the header and that the value is preceded by "size="
# "-d" is the maximal number of differences tolerated between 2 sequences to be gathered in the same OTU (1 here)
# "-o" option returns a ".txt" file in which each line corresponds to an OTU with all the amplicons belonging to this OTU
# "-w" option gives a "fasta" file with the representative sequence of each OTU
```
An option called _fastidious_ can be added, with  _-f_, in order to integrate small OTUs in larger related OTUs. We don't use it here because it doesn't change the output at all in our study. 

For more details on this SWARM processing step, see the original publication [here](https://doi.org/10.1038/nmeth.3869).

<a name="step24"></a>
### IV - 4 - SWARM + LULU processing step (Pipelines D)

For pipelines D, the same SWARM algorithm than in pipelines C was used, with an additional post-clustering step run thanks to the LULU algorithm.

LULU eliminates some OTUs by merging them to closest more abundant OTUs. The algorithm requires the OTU table procured by SWARM, and an OTU match list to provide the pairwise similarity scores of the OTUs, with a minimum threshold of sequence similarity set at 84% as recommended by the authors. Only OTU pairs with a sequence similarity above 84% can then be interpreted as “parent” for the most abundant one and “daughter” for the other.

As recommanded by the authors, the following line, running with the VSEARCH program, gives an OTU match list :
```
vsearch --usearch_global Aquarium_2.fasta --db Aquarium_2.fasta --self --id .84 --iddef 1 --userout match_list_Aquarium_2.txt -userfields query+target+id --maxaccepts 0 --query_cov .9 --maxhits 10
```

Both OTU will possibly be merged provided that the co-occurrence pattern of the OTU pair among samples is higher than 95% and the abundance ratio between the “potential parent” and “potential daughter” is higher than a minimum ratio set by default as the minimum observed ratio.

The following lines, run in a R IDE, process the post-clustering curation :
```
library("lulu")

OTUtable <- read.fasta(Aquarium_2.clustered.fasta)
matchlist <- read.table(match_list_Aquarium_2.txt)
# prepare the files needed for LULU processing

curated_results <- lulu(OTUtable, matchlist)
# LULU processing with the lulu R function

curated_results
# shows the OTU names and their abundance after the curation
```

For more details on LULU, see the original publication [here](https://doi.org/10.1038/nmeth.3869).

<a name="step3"></a>
## V - Abundance filtering step

In order to manipulate less data and to eliminate an important number of erroneous sequences, an abundance filtering is applied at this step. We used the _obigrep_ command from the OBITOOLS, to eliminate sequences with an abundance inferior to 10, with the following line :
```
obigrep -p 'count>=10' Aquarium_2.fasta > Aquarium_2.grep.fasta
# "-p 'count>=10'" option eliminates sequences with an abundance inferior to 10
```

In our study, this step permitted to eliminate a several number of sequences, without eliminated any true haplotype in the aquarium experiment.

<a name="step4"></a>
## VI - Post-processing steps

<a name="step41"></a>
### VI - 1 - No post-processing step (Pipelines A1/B1/C1/D1)

After the key processing step, you can decide to stop your pipeline here, use no more program and directly analyze your results.

<a name="step42"></a>
### VI - 2 - Bimeric sequences removal (Pipelines A2/B2/C2/D2)]

Definition : _We call chimeric sequences, or PCR-mediated recombinant, sequences built from a merging of different closely related DNA templates during PCR. By extension, we call bimeras the two-parent chimeric sequences._

For pipelines A2, B2, C2 and D2, sequences considered as bimeras, or two-parent chimeras, are removed using the _removeBimeraDenovo_ function from DADA2. This function mostly points out bimeras by aligning each sequence with all more abundant sequences and detecting a combination of an exact “right parent” and an exact “left parent” of this sequence.

You can remove the sequences considered as bimeras in the table by directly creating a new table, and repeating the same functions for create a new fasta file :

```
tab <- read.table(Aquarium_2.fasta, header=T)
seqtab_1 <- makeSequenceTable(tab)
seqtab_2 <- removeBimeraDenovo(seqtab_1, verbose=T)
# processes the bimera removal

uniqueSeqs <- getUniques(seqtab_2)
uniquesToFasta(uniqueSeqs, paste0(sample.names, ".fasta")
# creates the new file without bimeras
```

For more details on this DADA2 bimera removal step, see the original publication [here](https://doi.org/10.1038/nmeth.3869).

<a name="step43"></a>
### VI - 3 - Chimeric sequences removal (Pipelines A3/B3/C3/D3)]

For pipelines A3, B3, C3 and D3, chimeras are removed using *uchime3_denovo* command from VSEARCH program. This command is based on the UCHIME2 algorithm. Each sequence is divided into four segments, and the command mostly searches for similarity for each segment to all other sequences using a heuristic method. The best potential parent sequences are then selected, and the query sequence is considered as chimera if a set of default parameters is not exceeded.

The unique following line realizes this algorithm and gives the data without chimeras :
```
vsearch --uchime3_denovo Aquarium_2.fasta --nonchimeras Aquarium2_uchime3.fasta
```

For more details on this VSEARCH chimera removal step, see the original UCHIME2 publication [here](https://doi.org/10.1101/074252).

<a name="step5"></a>
## VII - Analyse your results

Now you can make a statistical analysis to evaluate your filtering quality, after comparing the amplicons returned by the pipeline with your reference dataset.
