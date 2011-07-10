#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::Differences;

{
    # TEST
    
    eq_or_diff(
        scalar(`$^X generate-abs-path.pl --seed=1`),
        <<'EOF',
Y | X | R | S | T
E | D | W | Q | U
F | B | C | V | P
G | A | K | L | O
H | I | J | N | M
EOF
        'For seed #1',
    );
}
