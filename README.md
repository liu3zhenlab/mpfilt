# mpfilt
To filter GFF outputs from miniprot

### Example run
```
./protmap 
```

## Output
### BED format
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

