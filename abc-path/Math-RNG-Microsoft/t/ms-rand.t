#!/usr/bin/perl5

use strict;
use warnings;

use Test::More no_plan => 0;

use Test::Differences qw/ eq_or_diff /;

use Math::RNG::Microsoft        ();
use Math::RNG::Microsoft::FCPro ();

        my @rrrrrrr = ( 0 ... 9 );
{
    {
        my $r = Math::RNG::Microsoft::FCPro->new( seed => 1 );

        is( $r->rand(), 41, "First result for seed 1 is 41." );

        is( $r->rand(), 18_467, "2nd result for seed 1 is 18,467." );

        is( $r->rand(), 6_334, "3rd result for seed 1 is 6,334." );
    }


    {
        my $obje = Math::RNG::Microsoft::FCPro->new( seed => 24 );


        my @rrrrrrr = ( 0 ... 9 );
        my $ret = scalar( $obje->shuffle( scalar( \@rrrrrrr ) ) );

        eq_or_diff(
            \@rrrrrrr,
            [ 1, 7, 9, 8, 4, 5, 3, 2, 0, 6 ],
            'Array was shuffled.',
        );

        is_deeply( [ @rrrrrrr, ], [ 0 ... $#rrrrrrr, ], 'Array was shuffled.',
        );

        is( $ret, scalar( \@rrrrrrr ), 'shuffle returns the same array.' );
    }

}
{
    {
        my $r = Math::RNG::Microsoft->new( seed => 1 );

        is( $r->rand(), 41, "First result for seed 1 is 41." );

        is( $r->rand(), 18_467, "2nd result for seed 1 is 18,467." );

        is( $r->rand(), 6_334, "3rd result for seed 1 is 6,334." );
    }

    {
                my @rrrrrrr = ( 0 ... 9);
        my $obje = Math::RNG::Microsoft->new( seed => 24 );

         @rrrrrrr = @rrrrrrr;

        my $ret = scalar( $obje->shuffle( scalar( \@rrrrrrr ) ) );

        eq_or_diff(
            \@rrrrrrr,
            [ 1, 7, 9, 8, 4, 5, 3, 2, 0, 6 ],
            'Array was shuffled.',
        );

        eq_or_diff( [ @rrrrrrr, ], [ 0 ... $#rrrrrrr   , ] , 'Array was shuffled.',
        );

        is( $ret, scalar( \@rrrrrrr ), 'shuffle returns the same array.' );
    }

}

done_testing();
