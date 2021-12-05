package Games::ABC_Path::MicrosoftRand;

use 5.006;
use strict;
use warnings;

=head1 NAME

Games::ABC_Path::MicrosoftRand - a pseudo-random number generator compatible
with Visual C.

=head1 SYNOPSIS

    use Games::ABC_Path::MicrosoftRand;

    my $randomizer = Games::ABC_Path::MicrosoftRand->new(seed => 24);

    my $random_digit = $randomizer->rand_max(10);

=head1 DESCRIPTION

This is a random number generator used by Games::ABC_Path::Generator, which
emulates the one found in Microsoft's Visual C++. It was utilised here, out
of familiarity and accessibility, because it is commonly used to generate
Freecell layouts in the Freecell world (see
L<http://en.wikipedia.org/wiki/FreeCell_%28Windows%29> ).

=cut

use integer;
use parent 'Math::RNG::Microsoft';

=head1 SUBROUTINES/METHODS

=head2 new

The constructor. Accepts a numeric seed as an argument.

    my $randomizer = Games::ABC_Path::MicrosoftRand->new(seed => 1);

=head2 $randomizer->rand()

Returns a random integer from 0 up to 0x7fff - 1.

    my $n = $randomizer->rand()

=head2 $randomizer->max_rand($max)

Returns a random integer in the range 0 to ($max-1).

    my $n = $randomizer->max_rand($max);
    # $n is now between 0 and $max - 1.

=head2 $randomizer->seed($seed)

Can be used to re-assign the seed of the randomizer (though not recommended).

=head2 my $array_ref = $randomizer->shuffle(\@array)

Shuffles the array reference of the first argument, B<destroys it> and returns
it. This is using the fisher-yates shuffle.

=cut

=head1 AUTHOR

Shlomi Fish, L<https://www.shlomifish.org/> .

=cut

1;    # End of Games::ABC_Path::MicrosoftRand
