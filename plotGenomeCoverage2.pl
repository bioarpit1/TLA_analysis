#!/usr/bin/perl 

#Cergentis software for TLA analysis

#The software below 
#generates genome coverage plots for all
#bam files in the user specified directory.

use strict;
use Getopt::Std;

my %options;
getopts('hi:o:',\%options) or usage();
usage() if $options{h};

my $file = __FILE__;
my $dir;
if($file=~/(.+)\/plotGenomeCoverage\.pl/){
	$dir = $1;
}
warn "running plotGenomeCoverage.pl\n\n";

# test for the existence of the required options.
if (!defined $options{i}) {print "\nNo input directory supplied \n\n"; usage();}
if (!defined $options{o}) {print "\nNo output directory supplied \n\n"; usage();}

#check end of paths
if ($options{i} =~ /(.+)\/$/){ $options{i}=$1; }
if ($options{o} =~ /(.+)\/$/){ $options{o}=$1; }

#store bams in global variable for downstream use
my @gfiles=glob "$options{i}/*.bam";

foreach my $g (@gfiles){	
	my $output_file;
	if($g=~/.+\/(.+)\.bam/){
		$output_file = $1;
	}
	else {
		warn "no bam files supplied to plotGenomeCoverage.pl\n\n";
		exit;
	}
	$output_file.='_coverage.txt';
	my $command = "samtools depth -Q 1 $g | perl windowed_coverage.pl > $options{o}/$output_file";
	print $command, "\n";
	system($command);	    	
}

#store txt files in global variable for downstream use
my @tfiles=glob "$options{o}/*_coverage.txt";

foreach my $t (@tfiles){	
		my $command = "Rscript GenomePlot.R $t";
		print $command, "\n";
		system($command);	    	
}




#-------------------------------------------------------------------------------------------------------------------
sub usage {
	warn 
	"\n-Cergentis software-\n".	
	"This program generates plots of the coverage accross the genome.\n".
	"Two sets of output files are generated. The output files with the name of the bam and the extension [_coverage.txt]\ncontain the read counts per window (region) in the genome. The output files with the extension [_coverage.png]\nare plots of the coverage across the genome\n".
	"-h :print help page\n".
	"-i :directory that contains the bam files\n".
	"-o :directory to which the output will be written. This directory needs to\n  exist before this tool is used. It will not be created automatically.\n".	
	"\n\n";
	exit;

}
