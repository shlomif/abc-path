package Games::ABC_Path::Generator::Coord;

use 5.006;

use strict;
use warnings;

use integer;

use parent 'Games::ABC_Path::Solver::Coord';

use Games::ABC_Path::Solver::Constants;

=head1 NAME

Games::ABC_Path::Generator::Coord - a coordinate class.

=cut

sub _from_int
{
    my ( $class, $int ) = @_;
    return $class->new( { y => ( $int / $LEN ), x => ( $int % $LEN ) } );
}

=head1 SYNOPSIS

B<For internal use.>.

=cut

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=cut

1;    # End of Games::ABC_Path::Generator::Coord
