package Games::ABC_Path::Generator::App;

use strict;
use warnings;

use Games::ABC_Path::Generator ();

sub run
{
    STDOUT->autoflush(1);
    foreach my $seed ( 1 .. 100 )
    {

        my $gen    = Games::ABC_Path::Generator->new( { seed => $seed, } );
        my $riddle = $gen->calc_riddle();
        my $riddle_string = $riddle->get_riddle_v1_string;

        printf( "ABC Path Solver Layout Version 1:\n%s", $riddle_string, );
    }
    return;
}

run;
