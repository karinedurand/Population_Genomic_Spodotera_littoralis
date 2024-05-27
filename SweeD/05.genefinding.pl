use strict;

# Input files
my $gffF = 'GCA_902850265.1_PGI_Spodlit_v1_genomic.CHROM.gff';  # GFF file containing genomic annotations
my $outlierF = 'result_EGTselected_data_SweeD_M_0_9995_OGD_FSTDXY';  # File containing outlier regions
my $output = 'PSgene_EGT_treshold.txt';  # Output file for genes overlapping outliers
my $tempF = 'temp';  # Temporary file for processing

# Copy the GFF file to a temporary file
`cp $gffF $tempF`;

# Hash to store outlier regions
my %OTL;
open my $fd_otl, $outlierF or die "Cannot open file $outlierF : $!";
while (<$fd_otl>) {
    next if /^chrN/;  # Skip the header line
    chomp;
    my ($chr, $start, $end) = (split)[0,4,5];
    for my $i ($start..$end) {
        $OTL{"$chr\t$i"} = 1;
    }
}
close $fd_otl;

# Process the GFF file to find genes overlapping with outlier regions
my $res;
open my $fd_temp, $tempF or die "Cannot open file $tempF : $!";
while (<$fd_temp>) {
    next unless /\tgene\t/;  # Process only lines that define genes
    chomp;
    my @cols = split("\t");
    my ($chr, $start, $end) = ($cols[0], $cols[3], $cols[4]);
    my @attributes = split(';', $cols[8]);
    my ($gene_id) = $attributes[0] =~ /ID=([^;]+)/;
    my ($gene_name) = $attributes[3] =~ /Name=([^;]+)/;
    
    my $included = 'no';
    for my $i ($start..$end) {
        if ($OTL{"$chr\t$i"}) {
            $included = $OTL{"$chr\t$i"};
            last;
        }
    }

    # If the gene overlaps with an outlier region, add it to the result
    if ($included ne 'no') {
        $res .= "$chr\t$start\t$end\t$gene_id\t$gene_name\n";
    }
}
close $fd_temp;

# Write the result to the output file
open my $fd_out, ">$output" or die "Cannot write to file $output : $!";
print $fd_out $res;
close $fd_out;

