use strict;
use warnings;
use Data::Dumper;
use File::Copy;

my %ensayos_copiados;
while(<*>){
	next if /^0/; 
	$ensayos_copiados{$_}=1 if -d'./0.fastqs/'.$_;
}
while(<*>){
	next if /^0/;
	next unless -d$_;
	my $ensayo=$_;
	next if defined $ensayos_copiados{$ensayo};
	mkdir "./0.fastqs/$ensayo";
	while (<./$ensayo/Data/Intensities/BaseCalls/*fastq.gz>){
		my $archivo=$_;
		print "Copiando ".$archivo,"\n";
		copy($archivo,"./0.fastqs/$ensayo/"); 
	}
}

