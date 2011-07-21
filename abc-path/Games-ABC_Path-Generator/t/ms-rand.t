#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Games::ABC_Path::MicrosoftRand;

{
    my $r = Games::ABC_Path::MicrosoftRand->new(seed => 1);

    # TEST
    is ($r->rand(), 41, "First result for seed 1 is 41.");

    # TEST
    is ($r->rand(), 18_467, "2nd result for seed 1 is 18,467.");

    # TEST
    is ($r->rand(), 6_334, "3rd result for seed 1 is 6,334.");
}
