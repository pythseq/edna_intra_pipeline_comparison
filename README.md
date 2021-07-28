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
  * [V - Post-processing steps](#step3)
    + [V - 1 - No post-processing step (Pipelines A1/B1/C1/D1)](#step31)
    + [V - 2 - Bimeric sequences removal (Pipelines A2/B2/C2/D2)](#step32)
    + [V - 3 - Chimeric sequences removal (Pipelines A3/B3/C3/D3)](#step32)
  * [VI - Analyse your results](#step4)

_________________________________

<a name="intro"></a>
## Introduction

This project aims to compare twelve bioinformatics pipelines based on five existing metabarcoding programs to make recommendations for data management in intraspecific variability studies using environmental DNA.
Data processing is necessary in metabarcoding studies to eliminate false sequences which are generated during amplification and sequencing, and particularly for intraspecific studies from eDNA samples, where the presence of false sequences in the data can over-estimate the intraspecific genetic variability.
That is why there is a need in filtering sequences with bioinformatics pipelines. Different bioinformatics tools have been developped for metabarcoding studies. Here, we propose to compare some of them, by building twelve unique pipelines.

For that, we use the following programs :

- [OBITOOLS](https://git.metabarcoding.org/obitools/obitools/wikis/home) : a set of commands written in python
- [DADA2](https://benjjneb.github.io/dada2/index.html) : a R package
- [SWARM](https://github.com/torognes/swarm) : a command written in C++
- [LULU](https://github.com/tobiasgf/lulu) : a R package
- [VSEARCH](https://github.com/torognes/vsearch) : a set of commands written in C++

In our study, we analyze the results of a paired-end sequencing, after extraction and amplification of filtrated eDNA from aquarium seawater, to detect intraspecific haplotypic variability in *Mullus surmuletus*.

<a name="install"></a>
## Installation

### Preliminary steps for OBITools

- First you need to have Anaconda installed

If it's not the case, click on this [link](https://www.anaconda.com/products/individual/get-started) and download it.

Install the download in your shell :
```
bash Anaconda3-2020.07-Linux-x86_64.sh
```

Then, close your shell and reopen it.
Verify conda is correctly installed. It should be here :
```
~/anaconda3/bin/conda
```

Write the following line :
```
conda config --set auto_activate_base false
```

- Create your new environment obitools from your root in your corresponding path. For example :
```
ENVYAML=./dada2_and_obitools/obitools_env_conda.yaml
conda env create -f $ENVYAML
```

Now you can activate your environment :
```
conda activate obitools
```
And deactivate it :
```
conda deactivate
```
### Preliminary steps for DADA2

### Preliminary steps for SWARM

### Preliminary steps for LULU

### Preliminary steps for VSEARCH