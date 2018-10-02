
#!/usr/bin/perl 

use strict;

my $window_size = 10e3;
my $window = -1;

my $coverage;
my $prev_chrom = "";
while(<>){
	my ($chrom, $start, @coverage) = split /\t/;
	my $curr_window = int($start / $window_size );
	if($curr_window == $window and $chrom eq $prev_chrom){
		$coverage += $_ for @coverage;
	}else{
		print join("\t", ($prev_chrom, $window*$window_size, $coverage)), "\n" if defined $coverage;
		$coverage = 0;
		$coverage += $_ for @coverage;
	}
	$window = $curr_window;
	$prev_chrom = $chrom;
}

print join("\t", ($prev_chrom, $window*$window_size, $coverage)), "\n";

