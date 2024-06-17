package Math::RNG::Microsoft;

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

use parent 'Math::RNG::Microsoft::Base';

use Class::XSAccessor {
    constructor => 'new',
    accessors   => [qw(seed)],
};

sub rand
{
    my $self = shift;
    $self->seed( ( $self->seed() * 214013 + 2531011 ) & (0x7FFF_FFFF) );
    return scalar( ( $self->seed >> 16 ) & 0x7fff );
}

sub _custom_bound
{
    my ( $self, $bigint, $max ) = @_;

    return ( $bigint % $max );
}

sub _private_max_random
{
    my ( $obj, $max ) = @_;

    my $bigint = scalar( $obj->rand() );
    my $result = scalar( $obj->_custom_bound( $bigint, $max ) );

    return $result;
}

sub max_rand
{
    my ( $obj, $max ) = @_;

    my $result = $obj->_private_max_random( $max, );

    return $result;
}

=head1 SUBROUTINES/METHODS

=head2 new

The constructor. Accepts a numeric seed as an argument.

    my $randomizer = Math::RNG::Microsoft->new(seed => 1);

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

1;    # End of Math::RNG::Microsoft
