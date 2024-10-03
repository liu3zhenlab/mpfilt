#!/usr/bin/perl -w
# Author: Sanzhen Liu
# Date: 10/1/2024

package mppkg;

# compare hits on the same regions from multiple proteins and select the "best" one
# input:
# 1. regional gff alignments from miniprot --gff-only
# output
# the best hit from a protein or multiple best hits if no significant overlaps among best hits 

#mini	miniprot	mRNA	1251165	1251461	534	+	.	ID=MP000042;Rank=1;Identity=0.9898;Positive=1.0000;Target=PWT7 1 98
#mini	miniprot	mRNA	1251165	1251461	538	+	.	ID=MP000043;Rank=1;Identity=1.0000;Positive=1.0000;Target=PWT7ELe_LomE 1 98
#mini	miniprot	mRNA	1251165	1251461	521	+	.	ID=MP000045;Rank=1;Identity=0.9694;Positive=0.9796;Target=PWT7Set 1 98

sub bestmatch {
	my $gff_aln = shift;

	return $best_hit;
}

1;

