package Games::ABC_Path::Solver::Move::ResultsInASuccess;

use strict;
use warnings;

use parent 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::ResultsInASuccess - indicates that a trial
selection resulted in an error.

=head1 SYNOPSIS

    use Games::ABC_Path::Solver::Move::ResultsInASuccess;

    my $move = Games::ABC_Path::Solver::Move::ResultsInASuccess->new(
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

sub _format
{
    return "Trying %(letter){letter} for %(coords){coords} returns a success.";
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

