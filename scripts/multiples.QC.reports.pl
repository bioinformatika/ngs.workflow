use strict;
use warnings;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Data::Dumper;
use File::Spec;

my %total_report;
my $dir_explore_fastqc_files="../datos.genomica/0.fastqs/150615_M03381_0004_000000000-AFG5J";
$dir_explore_fastqc_files = File::Spec->canonpath($dir_explore_fastqc_files) ;
die "Not a directory\t" unless -d$dir_explore_fastqc_files;
print $dir_explore_fastqc_files,"\n";
opendir(DH, $dir_explore_fastqc_files);
my @files = readdir(DH);
closedir(DH);
for(my $i=0;$i<$#files+1;$i++){
	next unless $files[$i]=~/fastqc\.zip$/;
	my $complete_path = File::Spec->catfile($dir_explore_fastqc_files,$files[$i]);
	die "Not a file! \t" unless -f$complete_path;
	my %info=extrae_info($complete_path);
	$total_report{$files[$i]}=\%info;
}

my $number_fastqczip_files=scalar keys %total_report;
print "A total of $number_fastqczip_files fastQC ZIP archives found\n";
print Dumper %total_report;

#open OUT,">","" or die "Can not open file ";

			#'Per base sequence quality' => 'FAIL',
            #'Per tile sequence quality' => 'WARN',
            #'Per sequence GC content' => 'FAIL',
            #'Basic Statistics' => 'PASS',
            #'Sequence Duplication Levels' => 'PASS',
            #'Per base N content' => 'PASS',
            #'Kmer Content' => 'WARN',
            #'Per base sequence content' => 'FAIL',
            #'Per sequence quality scores' => 'PASS',
            #'Adapter Content' => 'PASS',
            #'Sequence Length Distribution' => 'WARN',
            #'Overrepresented sequences' => 'WARN'


sub extrae_info{
	my $file=shift;
	my $zip = Archive::Zip->new();
	return 0 unless $zip->read($file) == AZ_OK;
	my @reports = $zip->membersMatching( 'summary.txt' );
	die "Not a report o more than one report file!\n" unless  1 == scalar @reports;
	$zip->extractMemberWithoutPaths($reports[0]);
	open IN,"<","summary.txt" or die "Not text file called 'summary.txt' generated!!!!\t";
	my %data;
	while(<IN>){
		chomp;
		my @cols=split /\t/;
		$data{$cols[1]}=$cols[0];
	}
	close IN;
	die "Error " unless unlink "summary.txt";
	return %data;
}
