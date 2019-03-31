#!perl -T

use strict;
use warnings;

use Test::More tests => 4;

BEGIN
{
    # TEST*4
    use_ok('Games::ABC_Path::Solver::Base');
    use_ok('Games::ABC_Path::Solver');
    use_ok('Games::ABC_Path::Solver::Move');
    use_ok('Games::ABC_Path::Solver::Board');
}

diag(
"Testing Games::ABC_Path::Solver::Base $Games::ABC_Path::Solver::Base::VERSION, Perl $], $^X"
);
