package Games::ABC_Path::Solver::Move::ResultsInAnError;

use strict;
use warnings;

use base 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::ResultsInAnError - indicates that a trial
selection resulted in an error.

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

    use Games::ABC_Path::Solver::Move::ResultsInAnError;

    my $move = Games::ABC_Path::Solver::Move::ResultsInAnError->new(
        {
            vars =>
            {
                letter => $letter,
                coords => [$x,$y],
            },
        }
    );

=head1 DESCRIPTION

This is a move that a branch resulted in an error.

=cut

sub _get_text {
    my $self = shift;

    my $text = $self->_format;

    $text =~ s/%\((\w+)\)\{(\w+)\}/
        $self->_expand_format($1,$2)
        /ge;

    return $text;
}

sub _format {
    return "Trying %(letter){letter} for %(coords){coords} results in an error.";
}

1;

