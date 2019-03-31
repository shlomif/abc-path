package Games::ABC_Path::Solver::Move::LastRemainingLetterForCell;

use strict;
use warnings;

use parent 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::LastRemainingLetterForCell - an ABC Path move
that indicates it's the last remaining letter for a given cell.

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

sub _format
{
    return
"The only letter that can be at %(coords){coords} is %(letter){letter}. Invalidating it for all other cells.";
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-abc_path-solver at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-ABC_Path-Solver>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::ABC_Path::Solver::Move


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-ABC_Path-Solver>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-ABC_Path-Solver>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-ABC_Path-Solver>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-ABC_Path-Solver/>

=back

=cut

1;
