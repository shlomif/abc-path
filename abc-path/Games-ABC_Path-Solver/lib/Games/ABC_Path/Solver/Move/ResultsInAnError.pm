package Games::ABC_Path::Solver::Move::ResultsInAnError;

use strict;
use warnings;

use parent 'Games::ABC_Path::Solver::Move';

=head1 NAME

Games::ABC_Path::Solver::Move::ResultsInAnError - indicates that a trial
selection resulted in an error.

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

sub _format
{
    return
        "Trying %(letter){letter} for %(coords){coords} results in an error.";
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=cut

1;
