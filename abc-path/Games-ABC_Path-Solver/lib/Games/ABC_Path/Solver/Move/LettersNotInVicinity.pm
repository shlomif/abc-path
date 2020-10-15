package Games::ABC_Path::Solver::Move::LettersNotInVicinity;

use strict;
use warnings;

use parent 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::LettersNotInVicinity - an ABC Path move
that indicates that letters are not in vicinity to one another in a certain
cell.

=head1 SYNOPSIS

    use Games::ABC_Path::Solver::Move::LettersNotInVicinity;

    my $move = Games::ABC_Path::Solver::Move::LettersNotInVicinity->new(
        {
            vars =>
            {
                target => 6
                coords => [1,2],
                source => 5,
            },
        }
    );

=head1 DESCRIPTION

This is a move that indicates that the C<'letter'> has the last remaining cell
as C<'coords'>.

=cut

sub _format
{
    return
"%(target){letter} cannot be at %(coords){coords} due to lack of vicinity from %(source){letter}.";
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=cut

1;

