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

=cut

1;

