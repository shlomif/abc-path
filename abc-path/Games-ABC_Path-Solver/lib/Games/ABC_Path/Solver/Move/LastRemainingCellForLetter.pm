package Games::ABC_Path::Solver::Move::LastRemainingCellForLetter;

use strict;
use warnings;

use parent 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::LastRemainingCellForLetter - an ABC Path move
that indicates it's the last remaining cell for a given letter.

=head1 SYNOPSIS

    use Games::ABC_Path::Solver::Move::LastRemainingCellForLetter;

    my $move = Games::ABC_Path::Solver::Move::LastRemainingCellForLetter->new(
        {
            vars =>
            {
                coords => [1,2],
                letter => 5,
            },
        }
    );

=head1 DESCRIPTION

This is a move that indicates that the C<'letter'> has the last remaining cell
as C<'coords'>.

=cut

sub _format
{
    return "For %(letter){letter} only %(coords){coords} is possible.";
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=cut

1;

