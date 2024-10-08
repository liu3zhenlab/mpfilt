#!/usr/bin/perl -w

# ===============================================================
# lookup.pl  
# 
# usage: perl lookup.pl <Input1> <Input2> [options]
#
# Input1: Query file (delim or csv file):
# Input2: Target file (delim or csv file); 
# Output: Add one more column on Query file
# ===============================================================

use strict;
use warnings;
use Getopt::Long;

my (@line, $Tkey_value, @T, %T, %total, %Tother, $target);
my ($help, $Qkey, $Tkey, $Tother, $Qrevcom, $intersect, $separator);
my ($qhead, $thead, $keystr, $label, $qskip, $tskip, $rmRedundance);

sub errINF {
	print <<EOF
	
  Usage: perl lookup.pl <Query> <Target> [options]
  [options]:
  --Qkey <num>      column number: search key in Query file (1)
  --Qhead           if specified, the header is present; no header by default
  --Qskip <num>     number of top rows to be skipped in the Query file (0)
  --Qrevcom         whether to reverse & complement key DNA sequences if failted to find the targets
  --Tkey <num>      column number: search key in Target file (1)
  --Tother <num>    column number: other column of information needed to be output in the Query result
  --rmRedundance    remove redundance if specified; off by default
  --Thead           if specified, the header is present; no header by default
  --Label <str>     label on the header of the added column
  --Tskip <num>     number of rows to be skipped in the Target file (0)
  --keystr <str>    string in the key needed to be removed before the comparison
  --separator <str> separator for columns (\\t)
  --intersect       only print out intersection if specified; off by default
  --help            help informatioin
	
EOF
}

GetOptions("Qkey=i" => \$Qkey, "Qhead" => \$qhead, "Qrevcom" => \$Qrevcom,
			"Thead" => \$thead, "Tkey=i" => \$Tkey, "Tother=i" => \$Tother,
			"Label=s" => \$label, "Qskip=i" => \$qskip, "Tskip=i" => \$tskip,
			"intersect" => \$intersect, "rmRedundance" => \$rmRedundance,
			"separator=s" => \$separator, "keystr=s" => \$keystr, "help" => \$help);

# judge parameters input
if ($help or @ARGV == 0) {
	&errINF;
	exit;
}

$Qkey = 1 if ! defined $Qkey;
$Tkey = 1 if ! defined $Tkey;
$qhead = (defined $qhead)? 1 : 0;
$thead = (defined $thead)? 1 : 0;
$label = defined $label ? $label : "Target";
$qskip = defined $qskip ? $qskip : 0;
$tskip = defined $tskip ? $tskip : 0;
#$keystr = defined $keystr ? $keystr : "";
$separator = defined $separator ? $separator : "\t";
$separator = ( $separator eq '\t' ) ? "\t" : $separator; # force it to be recognized as a tab separator
my %Totherdb;
my $count = 0;

# open Target:
open (IN, $ARGV[1]) || die "cannot open $ARGV[1]!\n";
for (my $i=0; $i<$tskip; $i++) {
	$_ = <IN>;
}
while (<IN>) {
	chomp;
	if ($_ !~ /^#/) {
		if ($thead and $count == 0) {
			my @label = split(/\Q$separator\E/,$_);
			if (defined $Tother) {
				$label = $label[$Tother-1];
			}
			$count++;
		} else {
			@line = split(/\Q$separator\E/, $_);
			$Tkey_value = $line[$Tkey-1]; # as hash values;
			if (defined $keystr) {
				$Tkey_value =~ s/$keystr//g;
			}
			if (!exists $Tother{$Tkey_value}) {
				if (defined $Tother) {
					$Tother{$Tkey_value} = $line[$Tother-1];
				} else {
					$Tother{$Tkey_value}++;
				}
			} else {
				if (defined $Tother) {
					if ($rmRedundance) {
						if (!exists $Totherdb{$Tkey_value}{$line[$Tother-1]}) {
							$Tother{$Tkey_value} .= ";".$line[$Tother-1];
							$Totherdb{$Tkey_value}{$line[$Tother-1]} = 1;
						}
					} else {
						$Tother{$Tkey_value} .= ";".$line[$Tother-1];
					}
				} else {
					$Tother{$Tkey_value}++;
				}
			}
		}
	}
}
close IN;

# open Query file:
$count = 0;
open (IN, $ARGV[0]) || die "Cannot open $ARGV[0].\n";
for (my $i=0; $i<$qskip; $i++) {
	$_ = <IN>;
}
while (<IN>) {
	chomp;
	if ($_ !~ /^\#/) {
		if ($qhead and $count==0) {
			chomp;
			print $_;
			print $separator;
			print "$label\n"; # print header
			$count++;
		} else {
			@line = split(/\Q$separator\E/, $_);
			$target = "-"; # initiate the target
			my $key_val = $line[$Qkey - 1];
			
			if (defined $keystr) {
				$key_val =~ s/$keystr//g;
			}
			# found a match
			if (exists $Tother{$key_val}) {
				$target = $Tother{$key_val};
				print "$_";
				print $separator;
				print "$target\n";
			} elsif ($Qrevcom) {
				my $key_val_revcom = &revcom($key_val);
				if (exists $Tother{$key_val_revcom}) {
					$target = $Tother{$key_val_revcom};
					print $_;
					print $separator;
					print "$target\n";
				} else {
					if (!$intersect) {
						print $_;
						print $separator;
						print "$target\n";
					}
				}
			} else {
				# output non-overlapping parts:	
				if (!$intersect) {
					print $_;
					print $separator;
					print "$target\n";
				}
			}
		}
	} else {
		print "$_\n";
	}
}
close IN;

#######################################
# module: reverse & complementary
#######################################
sub revcom {
	my $inseq = shift @_; 
	my $revcom = reverse($inseq);
	$revcom =~ tr/AGCTagct/TCGAtcga/;
	return $revcom;
}

