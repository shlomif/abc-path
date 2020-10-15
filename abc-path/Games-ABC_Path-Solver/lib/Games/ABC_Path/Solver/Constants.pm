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

=cut

1;
