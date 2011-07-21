#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

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

    my $layout = $riddle->get_final_layout();

    # TEST
    ok ($layout, "Layout was returned.");

    # TEST
    is ($layout->get_A_pos(), 16, "A_pos is correct.");
}
