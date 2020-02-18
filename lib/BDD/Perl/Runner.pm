use strict;
use warnings;
use 5.10.0;

package BDD::Perl::Runner;
use parent 'BDD::Runner';

my $singleton;

sub get_instance {
    $singleton = bless {
        definitions => [],
        ctx => {},
    }, shift unless $singleton;
    return $singleton;
}

sub run {
	my ($self, $arg) = @_;
	my $defs = $self->{definitions};
    die 'Runner has no registered definitions'
      unless @$defs > 0;
	for (@$defs) {
		my $regex   = $_->{regex};
		my $handler = $_->{handler};
		return &$handler($self->{ctx})
          if $arg =~ m/$regex/;
	}
    die "No match found for $arg";
}

sub can_run {
	my ($self, $arg) = @_;
	my $defs = $self->{definitions};
	for (@$defs) {
		my $regex   = $_->{regex};
        return 1
          if $arg =~ m/$regex/;
    }
    0;
}

sub load {
	my ($self, $step_file) = @_;
	require $step_file;
}

sub register {
    my ($self, $regex, $handler) = @_;
    push @{ $self->{definitions} }, {
        regex   => $regex,
        handler => $handler
	};
}

1;

