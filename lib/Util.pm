use strict;
use warnings;
use 5.10.0;

sub get_files {
    my $dir = shift;
    my @files = ();
    opendir my $dh, $dir or die "Can't open dir $dir: $!";
    while (readdir $dh) {
        next if $_ =~ m/^\.\.?$/;
        next unless -f $dir . $_;
        push @files, $_;
    }
    closedir $dh;
    @files;
}

1;

