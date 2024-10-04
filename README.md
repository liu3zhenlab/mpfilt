# protmap
To map proteins to genomic DNA sequences using miniprot

### Dependency
[miniprot](https://github.com/lh3/miniprot.git) needs to be installed and in the environment path.

### Usage
Here is an example to run protmap
```
../protmap --prot ../data/prot.fas --dna ../data/dna.fas
```

## Output
### GFF output
The GFF output is the filtered result from the miniprot GFF (--gff-only) output. The format remains the same.

### BED output
colunm | description
----------- | -----------
chr | chromosome or sequence ID in genomic DNA
start | 0-based start position
end | 1-based end position
mRNA | mRNA hit ID
rank | mRNA hit rank
strand | mRNA orientation
protein | query protein ID
alnmatch | ratio of the matched amino acid length to the alignment amino acid length
protmatch | ratio of the matched amino acid length to the protein length

## Contacts
Please report isssues or email [Sanzhen Liu](liu3zhen@ksu.edu) for questions.

