package Games::ABC_Path::Solver::Move::TryingLetterForCell;

use strict;
use warnings;

use parent 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::TryingLetterForCell - an ABC Path move
of trying a letter for a certain cell.

=head1 SYNOPSIS

    use Games::ABC_Path::Solver::Move::TryingLetterForCell;

    my $move = Games::ABC_Path::Solver::Move::TryingLetterForCell->new(
        {
            vars =>
            {
                coords => [1,2],
                letter => 5,
            },
        }
    );

=head1 DESCRIPTION

This is a move that indicates that we are attempting to solve the game by
trying to put the letter C<'letter'> in the coordinate C<'coords'>.

=cut

sub _format
{
    return
"We have non-conclusive cells. Trying %(letter){letter} for %(coords){coords}.";
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=cut

1;

