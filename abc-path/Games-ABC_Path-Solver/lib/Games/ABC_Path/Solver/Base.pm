package Games::ABC_Path::Solver::Base;

use warnings;
use strict;

use Games::ABC_Path::Solver::Constants;

=head1 NAME

Games::ABC_Path::Solver::Base - base class for Games::ABC_Path::Solver classes.

=head1 SYNOPSIS

    use parent 'Games::ABC_Path::Solver::Base';

    sub _init
    {

    }

=head1 FUNCTIONS

=head2 new

The default constructor - construct an object and calls _init.

=cut

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

use integer;

sub _xy_to_int
{
    my ( $self, $xy ) = @_;

=begin foo

    {
    my ($y, $x) = @{$xy}[$Y,$X];
    if (($x < 0) or ($x > $LEN_LIM))
    {
        confess "X $x out of range.";
    }

    if (($y < 0) or ($y > $LEN_LIM))
    {
        confess "Y $y out of range.";
    }
    }
=end foo

=cut

    return $xy->[$Y] * $LEN + $xy->[$X];
}

sub _to_xy
{
    my ( $self, $int ) = @_;

    return ( ( $int / $LEN ), ( $int % $LEN ) );
}

sub _y_indexes
{
    return ( 0 .. $LEN_LIM );
}

sub _x_indexes
{
    return ( 0 .. $LEN_LIM );
}

sub _x_in_range
{
    my ( $self, $x ) = @_;

    return ( $x >= 0 and $x < $LEN );
}

sub _y_in_range
{
    my ( $self, $y ) = @_;

    return $self->_x_in_range($y);
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-abc_path-solver at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-ABC_Path-Solver>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::ABC_Path::Solver::Base


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-ABC_Path-Solver>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-ABC_Path-Solver>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-ABC_Path-Solver>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-ABC_Path-Solver/>

=back

=cut

1;    # End of Games::ABC_Path::Solver::Base
