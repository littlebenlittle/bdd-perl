use strict;
use warnings;
use 5.10.0;

use BDD::Runner::Perl qw(register);

my $ctx = {};

register('Given', qr/I am (.*)/, sub {
    say "I now $1";
    $ctx->{iam} = $1;
});

register('Given', qr/I like (.*)/, sub {
    say "I now like $1";
    $ctx->{ilike} = $1;
});

register('Given', qr/there is (.*)/, sub {
    say "Some $1 appears!";
    $ctx->{thereis} = $1;
});

register('When', qr/I shoot rainbows/, sub {
    say 'Pew Pew!! 🌈🌈🌈';
    $ctx->{glitter} = 'everywhere';
});

register('When', qr/I scream/, sub {
    say 'AAAAAAAAAHHHH!!!';
    $ctx->{iscream} = 1;
});

register('Then', qr/there should be glitter everywhere/, sub {
    die 'Not enough glitter!'
      unless $ctx->{glitter} eq 'everywhere';
});

register('Then', qr/I get ice cream/, sub {
    die 'Only screamers get ice cream'
      unless $ctx->{iscream};
});

