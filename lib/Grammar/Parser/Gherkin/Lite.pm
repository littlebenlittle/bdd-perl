use strict;
use warnings;
use 5.10.1;

package Grammar::Parser::Gherkin::Lite;
use parent 'Grammar::Parser';

sub _load_step {
  my ($ctx, $kw, $arg) = @_;
  my $def = $ctx->{definitions}->match( $kw, $arg );
  $ctx->{undefined}->push( $kw, $arg )
    unless $def;
  $ctx->{scenario}->steps->push( $def );
  return uc $kw;
}

my $features = [];

sub new {
  my $class    = shift;
  my $filepath = shift;
  my $self  = Grammar::Parser->new($filepath);

  $self->register( 'BEGIN' => sub {
    my ($ctx, $line) = @_;
    return 'BEGIN' if $line =~ m/^\s*$/;
    if ($_ =~ m/Feature:\s*(.*)/) {
        my $feature = BDD::Model::Feature->new( $1 );
        push @$features, \$feature;
        $ctx->{feature} = \$feature;
        return 'FEATURE';
    }
    return 'HALT';
  });

  $self->register( 'FEATURE' => sub {
    my ($ctx, $line) = @_;
    my $feature = $ctx->{feature};
    if ($line =~ m/Background:\s*(.*)/) {
        die "Feature " . $feature->name . " already has a Background"
          if $feature->background;
        my $bg = BDD::Model::Background->new( $1 );
        $ctx->{feature}->background = \$bg;
        $ctx->{scenario} = \$bg;
        return 'BACKGROUND';
    }
    if ($line =~ m/Scenario:\s*(.*)/) {
        my $scenario = BDD::Model::Scenario->new( $1 );
        push @{ $ctx->{feature}->scenarios }, \$scenario;
        $ctx->{feature}->scenario = \$scenario;
        $ctx->scenario = \$scenario;
        return 'SCENARIO';
    }
    $feature->description .= $line;
    return 'FEATURE';
  });

  $self->register( 'BACKGROUND' => sub {
    my ($ctx, $line) = @_;
    my $feature = $ctx->{feature};
    if ($line =~ m/\s*Given\s*(.*)/) {
        _load_step( $ctx, 'Given', $1 );
    }
    $ctx->{scenario}->description .= $line;
    return 'FEATURE';
  });

  $self->register( 'SCENARIO' => sub {
    my ($ctx, $line) = @_;
    my $feature  = $ctx->{feature};
    if ($line =~ m/\s*(Given|When|Then)\s*(.*)/) {
        return _load_step( $ctx, $1, $2 );
    }
    $ctx->{scenario}->description .= $line;
    return 'SCENARIO';
  });

  $self->register( uc $_, sub {
    my ($ctx, $line) = @_;
    my $scenario = $ctx->{scenario};
    my $kw = ucfirst $_;
    if ($line =~ m/\s*(Given|And|But|When|Then)\s*(.*)/) {
        $1 =~ s/And|But/$kw/;
        return _load_step( $ctx, $1, $2 );
    }
    return 'WHEN';
  }) for qw(Given When Then);

  bless $self, $class;
}

