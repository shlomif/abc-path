package Math::RNG::Microsoft::Base;

use 5.006;
use strict;
use warnings;

=head1 NAME

Math::RNG::Microsoft::Base - base class

=head1 SYNOPSIS

    use Math::RNG::Microsoft::Base ();

    [For internal use.]

=head1 DESCRIPTION

For internal use.

=cut

use integer;

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

=head2 my $array_ref = $randomizer->shuffle(\@array)

Shuffles the array reference of the first argument, B<destroys it> and returns
it. This is using the fisher-yates shuffle.

=head2 my $new_array_ref = $randomizer->fresh_shuffle(\@array)

Copies the array reference of the first argument to a new array, shuffles it
and returns it. This is using the fisher-yates shuffle.

=cut

1;    # End of Math::RNG::Microsoft
