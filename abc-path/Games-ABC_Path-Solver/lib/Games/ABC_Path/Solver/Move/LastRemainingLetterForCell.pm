package Games::ABC_Path::Solver::Move::LastRemainingLetterForCell;

use strict;
use warnings;

use base 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::LastRemainingLetterForCell - an ABC Path move
that indicates it's the last remaining letter for a given cell.

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

    use Games::ABC_Path::Solver::Move::LastRemainingLetterForCell;

    my $move = Games::ABC_Path::Solver::Move::LastRemainingLetterForCell->new(
        {
            vars =>
            {
                coords => [1,2],
                letter => 5,
            },
        }
    );

=head1 DESCRIPTION

This is a move that indicates that the cell C<'coords'> has the last remaining
letter as C<'letter'>.

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
    return "The only letter that can be at %(coords){coords} is %(letter){letter}. Invalidating it for all other cells.";
}

1;

