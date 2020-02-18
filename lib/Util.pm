use strict;
use warnings;
use 5.10.0;

use File::Temp qw( tempfile );

sub get_files_from_dirpath {
    my $dir = shift;
    my @files = ();
    opendir my $dh, $dir or die "Can't open dir $dir: $!";
    while (readdir $dh) {
        my $path = $dir . '/' . $_;
        next if $_ =~ m/^\.\.?$/;
        next unless -f $path;
        push @files, $_;
    }
    closedir $dh;
    @files;
}

sub write_to_temp_file {
    my ($fh, $filename) = tempfile();
    print $fh shift;
    <$fh>;
    return $filename;
}

1;

