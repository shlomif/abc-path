package Math::RNG::Microsoft::Base;

use 5.006;
use strict;
use warnings;

=head1 NAME

Math::RNG::Microsoft - a pseudo-random number generator compatible
with Visual C.

=head1 SYNOPSIS

    use Math::RNG::Microsoft;

    my $randomizer = Math::RNG::Microsoft->new(seed => 24);

    my $random_digit = $randomizer->rand_max(10);

=head1 DESCRIPTION

This is a random number generator used by L<Games::ABC_Path::Generator>, which
emulates the one found in Microsoft's Visual C++. It was utilised here, out
of familiarity and accessibility, because it is commonly used to generate
Freecell layouts in the Freecell world (see
L<http://en.wikipedia.org/wiki/FreeCell_%28Windows%29> ).

B<NOTE:> This is not a cryptologically secure random number generator,
nor is it a particularly good one, so its use is discouraged unless
compatibility with the Windows C Run-time-library is needed.

=cut

use integer;

use Class::XSAccessor {
    constructor => 'new',
    accessors   => [qw(seed)],
};

sub fresh_shuffle
{
    my ( $self, $deck ) = @_;

    if ( not scalar(@$deck) )
    {
        return [];
    }
    my @d = @$deck;

    my $i = scalar(@d);
    while ( --$i )
    {
        my $j = scalar( $self->max_rand( $i + 1 ) );
        @d[ $i, $j ] = @d[ $j, $i ];
    }

    return scalar( \@d );
}

sub shuffle
{
    my ( $obj, $deck ) = @_;

    my $len    = scalar(@$deck);
    my $return = scalar( $obj->fresh_shuffle( scalar($deck) ) );
    if ($len)
    {
        if ( $return eq $deck )
        {
            die;
        }
        @$deck = @$return;
    }

    return $deck;
}

=head1 SUBROUTINES/METHODS

=head2 new

The constructor. Accepts a numeric seed as an argument.

    my $randomizer = Math::RNG::Microsoft->new(seed => 1);

=head2 $randomizer->rand()

Returns a random integer from 0 up to 0x7fff - 1.

    my $n = $randomizer->rand()

=head2 $randomizer->seed($seed)

Can be used to re-assign the seed of the randomizer (though not recommended).

=head2 my $array_ref = $randomizer->shuffle(\@array)

Shuffles the array reference of the first argument, B<destroys it> and returns
it. This is using the fisher-yates shuffle.

=head2 my $new_array_ref = $randomizer->fresh_shuffle(\@array)

Copies the array reference of the first argument to a new array, shuffles it
and returns it. This is using the fisher-yates shuffle.

=cut

1;    # End of Math::RNG::Microsoft
