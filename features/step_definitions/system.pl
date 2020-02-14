
use strict;
use warnings;

package BDD::Steps::System;

use Test::More;
use BDD::Runner::Perl;

my $runner = BDD::Runner::Perl->runner;
my $ctx = {};

$runner->register('When', qr/I run "(.*)"/, sub {
    $ctx->{'output'} = qx($1 2>&1);
    $ctx->{'exit_code'} = $? >> 8;
});

sub get_exit_code {
    my $exit_code = $ctx->{'exit_code'};
    $ctx->{'exit_code'} = undef;
    $exit_code;
}

$runner->register('Then', qr/the process returns exit code 0/, sub {
    my $exit_code = get_exit_code($ctx);
    ok $exit_code eq 0, "Expected exit code 0, got $exit_code";
});

$runner->register('Then', qr/the process returns a non-zero exit code/, sub {
    my $exit_code = get_exit_code($ctx);
    ok $exit_code ne 0, "Expected a non-zero exit code, got $exit_code";
});

$runner->register('Given', qr/I am at the root of the project/, sub {
    $ENV{PROJECT_ROOT} or die "Please set the environment variable PROJECT_ROOT";
    C->dispatch( 'When', "I change directory to \"" . $ENV{PROJECT_ROOT} . "\"" );
});

$runner->register('When', qr/I change directory to "(.*)"/, sub {
    chdir $1 or die "Could not chdir to $1: $!";
});

$runner->register('Then', qr/the file "(.*)" exists/, sub {
    ok -f $1;
});

$runner->register('Then', qr/the directory "(.*)" exists/, sub {
    ok -d $1;
});

