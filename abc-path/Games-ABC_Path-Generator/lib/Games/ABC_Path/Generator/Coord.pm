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

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-abc_path-generator at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-ABC_Path-Generator>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::ABC_Path::Generator


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-ABC_Path-Generator>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-ABC_Path-Generator>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-ABC_Path-Generator>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-ABC_Path-Generator/>

=back

=cut

1;    # End of Games::ABC_Path::Generator::Coord
