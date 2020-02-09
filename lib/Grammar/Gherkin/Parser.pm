use strict;
use warnings;
use 5.10.0;

package Grammar::Gherkin::Parser;
use parent 'Grammar::Parser';

use Grammar::Gherkin::Model::Feature;
use Grammar::Gherkin::Model::Scenario;
use BDD::Gherkin::Definitions;

sub _load_step {
  my ($self, $ctx, $kw, $arg) = @_;
  my $def = $self->{definitions}->match( $kw, $arg );
  push @{ $ctx->{undefined} }, [$kw, $arg]
    unless $def;
  push @{ $ctx->{scenario}->{steps} }, $def ;
  return uc $kw;
}

sub new {
  my ($class, $definitions) = @_;
  my $self = Grammar::Parser->new('BEGIN');

  $self->{features}    = [];
  $self->{definitions} = BDD::Gherkin::Definitions->new( $definitions );

  $self->register( 'BEGIN' => sub {
    my ($ctx, $line) = @_;
    return 'BEGIN' if $line =~ m/^\s\s*$/;
    if ($_ =~ m/Feature:\s*(.*)/) {
        my $feature = Grammar::Gherkin::Model::Feature->new( $1 );
        push @{ $self->{features} }, $feature;
        $ctx->{feature} = $feature;
        return 'FEATURE';
    }
    return 'HALT';
  });

  $self->register( 'FEATURE' => sub {
    my ($ctx, $line) = @_;
    my $feature = $ctx->{feature};
    if ($line =~ m/Background:\s*(.*)/) {
        die "Feature " . $feature->name . " already has a Background"
          if $feature->{background};
        my $bg = Grammar::Gherkin::Model::Scenario->new( $1 );
        $ctx->{feature}->{background} = $bg;
        $ctx->{scenario} = $bg;
        return 'BACKGROUND';
    }
    if ($line =~ m/Scenario:\s*(.*)/) {
        my $scenario = Grammar::Gherkin::Model::Scenario->new( $1 );
        push @{ $ctx->{feature}->{scenarios} }, \$scenario;
        $ctx->{feature}->{scenario} = $scenario;
        $ctx->{scenario} = $scenario;
        return 'SCENARIO';
    }
    $feature->{description} .= $line;
    return 'FEATURE';
  });

  $self->register( 'BACKGROUND' => sub {
    my ($ctx, $line) = @_;
    if ($line =~ m/\s*Given\s*(.*)/) {
        _load_step( $self, $ctx, 'Given', $1 );
    }
    $ctx->{scenario}->{description} .= $line;
    return 'FEATURE';
  });

  $self->register( 'SCENARIO' => sub {
    my ($ctx, $line) = @_;
    my $feature  = $ctx->{feature};
    if ($line =~ m/\s*(Given|When|Then)\s*(.*)/) {
        return _load_step( $self, $ctx, $1, $2 );
    }
    $ctx->{scenario}->{description} .= $line;
    return 'SCENARIO';
  });

  $self->register( uc $_, sub {
    my ($ctx, $line) = @_;
    my $scenario = $ctx->{scenario};
    my $kw = ucfirst $_;
    if ($line =~ m/\s*(Given|And|But|When|Then)\s*(.*)/) {
        $1 =~ s/And|But/$kw/;
        return _load_step( $self, $ctx, $1, $2 );
    }
    return 'WHEN';
  }) for qw(Given When Then);

  bless $self, $class;
}

1;

