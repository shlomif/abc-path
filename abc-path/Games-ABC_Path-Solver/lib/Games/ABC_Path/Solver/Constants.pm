package Games::ABC_Path::Solver::Constants;

use strict;
use warnings;

=head1 NAME

Games::ABC_Path::Solver::Constants - constants in use by the generator.
B<FOR INTERNAL USE!>.

=cut

use parent 'Exporter';

our $LEN        = 5;
our $LEN_LIM    = $LEN - 1;
our $BOARD_SIZE = $LEN * $LEN;
our $Y          = 0;
our $X          = 1;
our @letters    = (qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y));
our $NUM_CLUES  = ( 2 + $LEN + $LEN );

our $ABCP_MAX_LETTER = $#letters;

our @EXPORT =
    (qw($X $Y $NUM_CLUES @letters $LEN $LEN_LIM $BOARD_SIZE $ABCP_MAX_LETTER));

1;

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-abc_path-generator at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-ABC_Path-Solver>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::ABC_Path::Solver::Constants

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-ABC_Path-Solver>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-ABC_Path-Solver>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-ABC_Path-Solver>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-ABC_Path-Solver/>

=back

=cut

1;
