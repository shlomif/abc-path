package Games::ABC_Path::Solver::Coord;

use warnings;
use strict;

use parent 'Games::ABC_Path::Solver::Base';

=head1 NAME

Games::ABC_Path::Solver::Coord - X/Y coordinate class for the ABC Path classes.

=head1 SYNOPSIS

    use parent 'Games::ABC_Path::Solver::Base';

    sub _init
    {

    }

=head1 FUNCTIONS

=cut

use integer;

=head2 $coord->x()

B<For internal use>.

=cut

sub x
{
    my $self = shift;

    if (@_)
    {
        $self->{x} = shift;
    }

    return $self->{x};
}

=head2 $coord->y()

B<For internal use>.

=cut

sub y
{
    my $self = shift;

    if (@_)
    {
        $self->{'y'} = shift;
    }

    return $self->{'y'};
}

sub _to_s
{
    my $self = shift;

    return sprintf( "%d,%d", $self->x, $self->y );
}

sub _init
{
    my ( $self, $args ) = @_;

    $self->x( $args->{x} );
    $self->y( $args->{'y'} );

    return;
}

sub _equal
{
    my ( $self, $other_xy ) = @_;

    return ( ( $self->x == $other_xy->x ) && ( $self->y == $other_xy->y ) );
}

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/>

=cut

1;    # End of Games::ABC_Path::Solver::Base
