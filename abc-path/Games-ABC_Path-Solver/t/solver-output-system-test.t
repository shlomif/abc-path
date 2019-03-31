#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;
use Test::Differences qw( eq_or_diff );

sub _slurp
{
    my $filename = shift;

    open my $in, "<", $filename
        or die "Cannot open '$filename' for slurping - $!";

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

{
    my $got_results =
`$^X -Mblib bin/abc-path-solve t/layouts/brain-bashers.2010-12-21.abc-path`;

    # TEST
    ok( ( !$? ), "Process ended successfully." );

    my $exp_results =
        _slurp('./t/results/brain-bashers.2010-12-21.abc-path-sol');

    # TEST
    eq_or_diff( $got_results, $exp_results, "Output is OK.", );
}

{
    my $got_results =
`$^X -Mblib bin/abc-path-solve t/layouts/brain-bashers.2010-12-22.abc-path`;

    # TEST
    ok( ( !$? ), "Process ended successfully." );

    my $exp_results =
        _slurp('./t/results/brain-bashers.2010-12-22.abc-path-sol');

    # TEST
    eq_or_diff( $got_results, $exp_results, "Output is OK.", );
}

{
    my $got_results = `$^X -Mblib bin/abc-path-solve --gen-v1-template`;

    # TEST
    ok( ( !$? ), "Process ended successfully." );

    my $v1_template__exp_results = <<'EOF';
ABC Path Solver Layout Version 1:
???????
?     ?
?     ?
?     ?
?   A ?
?     ?
???????
EOF

    # TEST
    eq_or_diff( $got_results, $v1_template__exp_results,
        "Output of --gen-v1-template is OK.",
    );
}
