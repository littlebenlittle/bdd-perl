use strict;
use warnings;
use 5.10.0;

package Grammar::Gherkin::Parser;
use parent 'Grammar::Parser';

use Grammar::Gherkin::Model::Feature;
use Grammar::Gherkin::Model::Scenario;

sub _push_step_context {
    my ($self, $ctx, $kw, $arg) = @_;
    die 'Blank follows keyword'
      unless $arg;
    my $step = [$kw, $arg];
    push @{ $ctx->{undefined} }, [$kw, $arg]
      unless $step;
    push @{ $ctx->{scenario}->{steps} }, $step;
}

sub _push_scenario_context {
    my ($ctx, $name) = @_;
    my $scenario = Grammar::Gherkin::Model::Scenario->new( $name );
    push @{ $ctx->{feature}->{scenarios} }, $scenario;
    $ctx->{feature}->{scenario} = $scenario;
    $ctx->{scenario} = $scenario;
}

sub new {
    my $self  = Grammar::Parser->new('BEGIN');
    $self->{features} = [];

    $self->register( 'BEGIN' => sub {
        my ($ctx, $line) = @_;
        return 'BEGIN' if $line =~ m/^$/;
        if ($_ =~ m/Feature:\s*(.*)/) {
            my $feature = Grammar::Gherkin::Model::Feature->new( $1 );
            push @{ $self->{features} }, $feature;
            $ctx->{feature} = $feature;
            return 'FEATURE';
        }
        "Expected Feature; found $line";
    });

    $self->register( 'FEATURE' => sub {
        my ($ctx, $line) = @_;
        my $feature = $ctx->{feature};
        if ($line =~ m/Background:\s*(.*)/) {
            die "Feature " . $feature->name . " already has a Background"
              if $feature->{background};
            _push_scenario_context( $ctx, $1 );
            $ctx->{feature}->{background} = $ctx->{scenario};
            return 'BACKGROUND';
        }
        if ($line =~ m/Scenario:\s*(.*)/) {
            _push_scenario_context( $ctx, $1 );
            return 'SCENARIO';
        }
        $feature->{description} .= $line;
        return 'FEATURE';
    });

    $self->register( 'BACKGROUND' => sub {
        my ($ctx, $line) = @_;
        my $kw = 'Given';
        if ($line =~ m/\s*$kw\s*(.*)/) {
            _push_step_context( $self, $ctx, 'Given', $1 );
            return uc $kw;
        }
        $ctx->{scenario}->{description} .= $line;
        return 'FEATURE';
    });

    $self->register( 'SCENARIO' => sub {
        my ($ctx, $line) = @_;
        my $feature  = $ctx->{feature};
        if ($line =~ m/\s*(Given|When|Then)\s*(.*)/) {
            _push_step_context( $self, $ctx, $1, $2 );
            return uc $1;
        }
        $ctx->{scenario}->{description} .= $line;
        return 'SCENARIO';
    });

    $self->register( 'GIVEN' => sub {
        my ($ctx, $line) = @_;
        my $base_kw = 'Given';
        return uc $base_kw if $line =~ m/^\s*$/;
        if ($line =~ m/\s*($base_kw|And|But)\s\s*(.*)/) {
            my $kw  = $1;
            my $arg = $2;
            $kw =~ s/And|But/$base_kw/;
            _push_step_context( $self, $ctx, $kw, $arg );
            return uc $kw;
        }
        if ($ctx->{scenario} eq $ctx->{feature}->{background}) {
            if ($line =~ m/Scenario:\s*(.*)/ ) {
                _push_scenario_context( $ctx, $1 );
                return 'SCENARIO';
            }
        } elsif ($line =~ m/(When|Then)\s\s*(.*)/) {
            my $kw  = $1;
            my $arg = $2;
            _push_step_context( $self, $ctx, $kw, $arg );
            return uc $kw;
        }
        return "Unrecognized line in GIVEN context: $line";
    });

    $self->register( 'WHEN' => sub {
        my ($ctx, $line) = @_;
        my $base_kw = 'When';
        return uc $base_kw if $line =~ m/^\s*$/;
        if ($line =~ m/\s*($base_kw|And|But)\s\s*(.*)/) {
            my $kw  = $1;
            my $arg = $2;
            $kw =~ s/And|But/$base_kw/;
            _push_step_context( $self, $ctx, $kw, $arg );
            return uc $kw;
        }
        if ($line =~ m/\s*(Then|And|But)\s\s*(.*)/) {
            _push_step_context( $self, $ctx, 'Then', $2 );
            return 'THEN';
        }
        return 'HALT';
    });

    $self->register( 'THEN' => sub {
        my ($ctx, $line) = @_;
        my $base_kw = 'Then';
        return uc $base_kw if $line =~ m/^\s*$/;
        if ($line =~ m/\s*($base_kw|And|But)\s\s*(.*)/) {
            my $kw  = $1;
            my $arg = $2;
            $kw =~ s/And|But/$base_kw/;
            _push_step_context( $self, $ctx, $kw, $arg );
            return uc $kw;
        }
        if ($line =~ m/Scenario:\s*(.*)/ ) {
            _push_scenario_context( $ctx, $1 );
            return 'SCENARIO';
        }
        return 'HALT';
    });

    bless $self, shift;
}

sub before {
    my ($self, $ctx) = @_;
    $ctx = {
      undefined => [],
    };
}

1;

