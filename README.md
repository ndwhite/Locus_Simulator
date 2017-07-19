# Locus_Simulator
Please cite use of this software.

This script creates randomized loci from a de-interleaved fasta-format genome file. It takes into account the probability of a random locus being on a given contig by using the length of each contig relative to the entire genome. It was designed to create a "control" dataset for comparing the intersection of UCEs with genome annotation files, but can be used for any similar purpose. Note that you may want to change the number (currently set to 5,472; line 100) and length of loci generated (currently set to 120 bp; lines 68, 110, 115 & 116).

Execute with command "perl Locus_simulator.pl <your_genome.fa>". Output will be a BED-formated file named <your_genome.fa>.bed. It look like:

    chr20	440371	440491	sim_1
    chr1	171459005	171459125	sim_2
    chr10	17882451	17882571	sim_3
    chr3	41464258	41464378	sim_4
    chr5	46403014	46403134	sim_5
