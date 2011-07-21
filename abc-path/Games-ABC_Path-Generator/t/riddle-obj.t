#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Games::ABC_Path::Generator;

{
    my $gen = Games::ABC_Path::Generator->new({seed => 1});

    my $riddle = $gen->calc_riddle();

    # TEST
    ok ($riddle, "Riddle was initialized");

    # TEST
    is ($riddle->get_riddle_v1_string(),
        <<'EOF',
YGBJNUT
S     R
D     W
F     V
O A   K
M     I
HEXCQPL
EOF
        "get_riddle_v1_string()",
    );
}
