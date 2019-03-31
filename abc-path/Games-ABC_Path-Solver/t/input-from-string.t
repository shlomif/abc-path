#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Differences;

use Games::ABC_Path::Solver::Board;

{
    my $input_string = <<'EOF';
OWXIBQN
J    AK
E     L
U     F
Y     P
R     S
TVMGCDH
EOF

    my $solver =
        Games::ABC_Path::Solver::Board->input_from_v1_string($input_string);

    # TEST
    ok( $solver, "Solver was initialized." );

    $solver->solve();

    # TEST
    is( scalar( @{ $solver->get_successful_layouts() } ),
        1, "One successful layout" );

    # TEST
    eq_or_diff(
        $solver->get_successes_text_tables(),
        [ <<'EOF' ],
| X = 1 | X = 2 | X = 3 | X = 4 | X = 5 |
|   K   |   J   |   I   |   B   |   A   |
|   L   |   H   |   G   |   C   |   E   |
|   U   |   M   |   N   |   F   |   D   |
|   V   |   T   |   Y   |   O   |   P   |
|   W   |   X   |   S   |   R   |   Q   |
EOF
        "Success table is right.",
    );
}
