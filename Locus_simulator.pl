#!/usr/bin/perl
use List::Util qw(min max sum);
use Data::Dumper;

#Open genome file
open (FILE, $ARGV[0]) || die "Come again?\n";
open (OUTPUT, ">$ARGV[0].bed") || die "Can't open output\n";

$genomelength=0;
$num_scaffolds = 0;
$initial = 1;
%hash_length = ();
%hash_scaffNumber = ();
%hash_scaffProb = ();
$Num_UCEs_wanted = 0;

#Read in everything
	#Create hash of scaffolds and **their length-120bp**
	#Sum over length of whole file
#Do for first entry first
$line = <FILE>;
chomp $line;
@array = split (">", $line);
$header = $array[1];
$num_scaffolds++;

print $header;

$line = <FILE>;
chomp $line;
$scaffold_length = length $line;
print "\t".$scaffold_length."\n";
$upperlimit = $scaffold_length;
@$header = ($initial..$upperlimit);
print $initial."\t".$upperlimit."\n";
$hash_scaffNumber{$header} = $num_scaffolds;
$hash_length{$header} = $scaffold_length;
$initial += $scaffold_length;
$genomelength += $scaffold_length;

#Do for the rest of the file
until (eof FILE) {
	$line = <FILE>;
	chomp $line;
	if ($line =~ m/>/){
			@array = split (">", $line);
			$header = $array[1];
			print $header;
			$num_scaffolds++;

		} else {
			$scaffold_length = length $line;
			$genomelength += $scaffold_length;
			print "\t".$scaffold_length."\n";
			$upperlimit = $initial + $scaffold_length - 1;
			print $initial."\t".$upperlimit."\n";
			$hash_length{$header} = $scaffold_length;
			$hash_scaffNumber{$header} = $num_scaffolds;
 			$initial += $scaffold_length;
		}	
}

print "genome length: $genomelength\n";
print "Number of scaffolds: $num_scaffolds\n";


#Calculate genome length minus the length of the loci we want to generate
$usable_genome_length = $genomelength - 120;
print "Usable genome length:$usable_genome_length\n";


#Grab a random number between 1 and the usable length of the genome
$random = int(rand($usable_genome_length));
print "integer between 1 and genome length: $random\n";


#Determine per bp probability
	#Multiple that probability by the length of a given scaffold if rand() is < that product, pick that scaffold; else, repeat
$perBPprob = 1/$genomelength;
print "Per BP probability = $perBPprob\n";

#Determine per bp probability over all scaffold lengths; create hash of these values
for $key (keys %hash_length) {
	$value = $hash_length{$key};
	$ScaffBPprobability = $value * $perBPprob;
	$hash_scaffProb{$key} = $ScaffBPprobability;
	print "$key\t$ScaffBPprobability\n";
	}


#Generate 5,000 UCEs; until counter =5,000
	#counter = 0
	#use random number to pick which chromosome, based on probability of hitting that chromosome
	#(this probability calculated as (5,000*120)/length of whole genome)
		#use random number to pick starting coord from length of that chromosome
		#add 120bp to that coord
		#counter++
	
		
until ($Num_UCEs_wanted eq 5472) {
	#add 1 so you don't include 0
	$UCE_loop_random = int(rand($num_scaffolds)) + 1;
	$scaffoldNumber = "chr".$UCE_loop_random;
	$scaffoldProbability_to_compare = $hash_scaffProb{$scaffoldNumber};
	$Random_bp_probability = rand(1);

	if ($Random_bp_probability < $scaffoldProbability_to_compare) {
			$Num_UCEs_wanted++;
			$scaffold_short = $hash_length{$scaffoldNumber};
				if ($scaffold_short < 120) {
						$startcoord = 1;
						$endcoord = $scaffold_short;
						print STDERR "Scaffolds shorter than 120bp present\n";
					} else {
						$startcoord = int(rand($hash_length{$scaffoldNumber} - 120));
						$endcoord = $startcoord + 120;
					}

			print OUTPUT "$scaffoldNumber\t$startcoord\t$endcoord\tsim_$Num_UCEs_wanted\n";
		} else {
		}

	}
	
	end;
