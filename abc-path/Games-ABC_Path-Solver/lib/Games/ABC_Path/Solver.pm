package Games::ABC_Path::Solver;

use warnings;
use strict;

use 5.008;

=encoding utf8

=head1 NAME

Games::ABC_Path::Solver - a solver for ABC Path

=head1 SYNOPSIS

See L<Games::ABC_Path::Solver::Board> for more information.

=head1 How to play? The Rules of the Game

The 5*5 grid must be filled with a contiguous path of the first 25 (= 5 * 5)
letters of the Latin alphabet (“A” to “Y”), in order. Moves in the path can be
diagonal, but they cannot wrap through the edges of the grid.

The position of the letter “A” is given. In addition, for every horizontal
row, vertical column, and the two diagonals, there are two letters that should
appear in them (but in any order, and with possible gaps).

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=cut

1;    # End of Games::ABC_Path::Solver
