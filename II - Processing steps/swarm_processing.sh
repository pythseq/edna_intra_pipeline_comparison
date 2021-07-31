## use the swarm command to make the gathering :
swarm -z -d 1 -o stats_Aquarium_2.txt -w Aquarium_2.clustered.fasta < Aquarium_2.fasta

## "-z" option permits to accept the abundance in the header, provided
## that there is no space in the header and that the value is preceded
## by "size="

## "-d" is the maximal number of differences tolerated between two
## sequences to be gathered in the same OTU (1 here)

## "-o" option returns a ".txt" file in which each line corresponds to
## an OTU with all the amplicons belonging to this OTU

## "-w" option gives a "fasta" file with the representative sequence of 
## each OTU
