package Math::RNG::Microsoft::FCPro;

use 5.014;
use strict;
use warnings;
use integer;
use bigint;

=head1 NAME

Math::RNG::Microsoft::FCPro - a pseudo-random number generator compatible
with Visual C with Freecell Pro extended seeds.


=head1 SYNOPSIS

    use Math::RNG::Microsoft::FCPro ();

    my $randomizer = Math::RNG::Microsoft::FCPro->new(seed => 24);

    my $random_digit = $randomizer->rand_max(10);

=head1 DESCRIPTION

This is a random number generator used by L<Freecell::Deal::MS> which
emulates the one found in Microsoft's Visual C++. It was utilised here, out
of familiarity and accessibility, because it is commonly used to generate
Freecell layouts in the Freecell world (see
L<http://en.wikipedia.org/wiki/FreeCell_%28Windows%29> ).

B<NOTE:> This is not a cryptologically secure random number generator,
nor is it a particularly good one, so its use is discouraged unless
compatibility with the Windows C Run-time-library is needed.

=cut

my $MAX_SEED = ( ( 1 << ( 31 + 2 ) ) - 1 );    # 33 bits

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

sub _seed
{
    my $self = shift;

    if (@_)
    {
        $self->{_seed} = shift;
    }

    return $self->{_seed};
}

sub _seedx
{
    my $self = shift;

    if (@_)
    {
        $self->{_seedx} = shift;
    }

    return $self->{_seedx};
}

my $X = hex("0x100000000");

sub _init
{
    my ( $self, %args ) = @_;

    my $seed = $self->_seed( $args{seed} );
    $self->_seedx( ( $seed < $X ) ? $seed : ( $seed - $X ) );
    return;
}

sub rand
{
    my ( $self, ) = @_;

    if ( $self->_seed < $X )
    {
        my $ret = $self->_rando();
        return ( ( $self->_seed < 0x80000000 ) ? $ret : ( $ret | 0x8000 ) );
    }
    else
    {
        return $self->_randp() + 1;
    }
}

sub _rando
{
    my $self = shift;
    $self->_seedx( ( $self->_seedx() * 214013 + 2531011 ) & $MAX_SEED );
    return ( ( $self->_seedx >> 16 ) & 0x7fff );
}

sub _randp
{
    my $self = shift;
    $self->_seedx( ( $self->_seedx() * 214013 + 2531011 ) & $MAX_SEED );
    return ( ( $self->_seedx >> 16 ) & 0xffff );
}

sub max_rand
{
    my ( $self, $max ) = @_;

    return ( $self->rand() % $max );
}

sub shuffle
{
    my ( $self, $deck ) = @_;

    if (@$deck)
    {
        my $i = @$deck;
        while ( --$i )
        {
            my $j = $self->max_rand( $i + 1 );
            @$deck[ $i, $j ] = @$deck[ $j, $i ];
        }
    }

    return $deck;
}

=head1 SUBROUTINES/METHODS

=head2 new

The constructor. Accepts a numeric seed as an argument.

    my $randomizer = Math::RNG::Microsoft::FCPro->new(seed => 1);

=head2 $randomizer->rand()

Returns a random integer from 0 up to 0x7fff - 1.

    my $n = $randomizer->rand()

=head2 $randomizer->max_rand($max)

Returns a random integer in the range 0 to ($max-1).

    my $n = $randomizer->max_rand($max);
    # $n is now between 0 and $max - 1.

=head2 my $array_ref = $randomizer->shuffle(\@array)

Shuffles the array reference of the first argument, B<destroys it> and returns
it. This is using the fisher-yates shuffle.

=cut

1;
