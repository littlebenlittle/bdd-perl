use strict;
use warnings;
use 5.10.0;

package BDD::Runner::PHP;
use parent 'BDD::Runner';
use Grammar::Parser;

my $PHP_FUNCTION_REGEX     = qr/^\s*function \(([^\)\w\s,]*)\).*$/;
my $PHP_BEGINCOMMENT_REGEX = qr/^\s*\/\*.*$/;
my $PHP_ENDCOMMENT_REGEX   = qr/^\s*\*\/.*$/;
my $GIVEN_REGEX = qr/^\s*\*?\@Given\s\s*(.*)$/;
my $WHEN_REGEX  = qr/^\s*\*?\@When\s\s*(.*)$/;
my $THEN_REGEX  = qr/^\s*\*?\@Then\s\s*(.*)$/;

sub new {
    my ($class, $definitions) = @_;
    my $runner = BDD::Runner->new;
    my $parser = Grammar::Parser->new;

    $parser->register_init( 'BEGIN', sub {
        my ($ctx, $line) = @_;
        $line =~ s/\s*//g;
        return 'BEGIN' if $line =~ m/^$/;
        return 'PHP'   if $line =~ m/^<\?php$/;
    });
    
    $parser->register( 'PHP', sub {
        my ($ctx, $line) = @_;
        return 'PHP' if $line =~ m/^$/;
        return 'PHP' if $line =~ m/^\$.*$/;
        $ctx->{parent_context} = 'PHP';
        return 'COMMENT'  if $line =~ m/$PHP_BEGINCOMMENT_REGEX/;
        return 'FUNCTION' if $line =~ m/$PHP_FUNCTION_REGEX/;
    });
    
    $parser->register( 'COMMENT', sub {
        my ($ctx, $line) = @_;
        return $ctx->{parent_context} if $line =~ m/$PHP_ENDCOMMENT_REGEX/;
        if ($line =~ m/$GIVEN_REGEX/) {
            my $fn_body = '';
            push @{ $runner->{given_steps} }, [$1, \$fn_body];
            return 'GIVEN';
        }
        'COMMENT';
    });
    
    $parser->register( 'FUNCTION', sub {
        my ($ctx, $line) = @_;
        "FUNCTION handler undefined in " . __FILE__ . " at line $.";
    });
    
    $parser->parse( $_ ) for @$definitions;
    bless $runner, $class;
}

sub run {
    my ($self, $step) = @_;
}

1;

