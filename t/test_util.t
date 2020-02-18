use strict;
use warnings;
use 5.10.0;

use Test::More;
use Util qw( get_files_from_dirpath write_to_temp_dir );
use File::Temp qw( tempdir );


my $message = <<EOF;
Here there be text
EOF
my $filename = write_to_temp_file($message);
my $tempfile_content = do {
    open my $fh, '<', $filename or die "Cannot open $filename: $!";
    undef local $/;
    <$fh>;
};
is $tempfile_content, $message, 'Can write and read from temp file';


my $dirname = tempdir();
# opendir my $dh, $dirname or die "Can't opendir $dirname: $!";
ok( get_files_from_dirpath($dirname) == 0, 'New temp dir is empty' );
my $tempdir_filename = $dirname . '/test.txt';
my $tempdir_message  = 'Here there be some other text';
do {
    open my $fh, '>', $tempdir_filename or die "Cannot open $tempdir_filename: $!";
    print $fh $tempdir_message;
};

my @files = get_files_from_dirpath($dirname);
ok( @files != 0, 'Temp dir is not empty after writing to file' );
ok( (grep {/test\.txt/} @files), 'A file that exists is returned from get_files');
ok( (not grep {/bish\.boombash/} @files), 'A file that does not exist is not returned from get_files');

my $subdirname = $dirname . '/' . 'my_dir';
mkdir $subdirname;
ok( -d $subdirname, 'A subdirectory in the tempdir is created');
ok( (not grep {/my_dir/} @files), 'A subdirectory is not returned from get_files');

done_testing();

