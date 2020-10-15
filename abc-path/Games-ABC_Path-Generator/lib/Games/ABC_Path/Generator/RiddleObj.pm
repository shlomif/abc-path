package Games::ABC_Path::Generator::RiddleObj;

use 5.006;

use strict;
use warnings;

use Carp;

use integer;

use parent 'Games::ABC_Path::Solver::Base';

use Games::ABC_Path::Solver::Constants;

=head1 NAME

Games::ABC_Path::Generator::RiddleObj - represents a riddle.

=head1 SYNOPSIS

    use Games::ABC_Path::Generator;

    my $gen = Games::ABC_Path::Generator->new({seed => 1});

    # Returns a Games::ABC_Path::Generator::RiddleObj object.
    my $riddle = $gen->calc_riddle();

    print $riddle->get_riddle_v1_string();
    print $riddle->get_riddle_string_with_header();


=head1 SUBROUTINES/METHODS

=head2 my $riddle = Games::ABC_Path::Generator::RiddleObj->new({%args});

Initialised a new riddle. Arguments are:

=over 4

=item * solution

The solution layout.

=item * clues

An array of the clues.

=item * A_pos

The position of the A cell.

=back

=cut

sub _solution
{
    my $self = shift;

    if (@_)
    {
        $self->{_solution} = shift;
    }

    return $self->{_solution};
}

sub _clues
{
    my $self = shift;

    if (@_)
    {
        $self->{_clues} = shift;
    }

    return $self->{_clues};
}

sub _A_pos
{
    my $self = shift;

    if (@_)
    {
        $self->{_A_pos} = shift;
    }

    return $self->{_A_pos};
}

sub _init
{
    my $self = shift;
    my $args = shift;

    $self->_solution( $args->{solution} );
    $self->_clues( $args->{clues} );
    $self->_A_pos( $args->{A_pos} );

    return;
}

=head2 my [$letter1, $letter2] = $riddle->get_letters_of_clue({ type => $type, index => $index, })

Returns the two letters (as an array reference) associated with the
clue represented by the hash reference. Type can be:

=over 4

=item * 'col'

A column clue. C<'index'> points to the X coordinate.

=item * 'row'

A row clue. C<'index'> points to the Y coordinate.

=item * 'diag'

The diagonal clue. C<'index'> is ignored.

=item * 'antidiag'

The anti-diagonal clue. C<'index'> is ignored.

=back

Some examples:

    my $letters_aref = $riddle->get_letters_of_clue({ type => 'col', index => 2, });
    my $letters_aref = $riddle->get_letters_of_clue({ type => 'row', index => 1, });
    my $letters_aref = $riddle->get_letters_of_clue({ type => 'diag', });
    my $letters_aref = $riddle->get_letters_of_clue({ type => 'antidiag', });

=cut

sub get_letters_of_clue
{
    my ( $self, $args ) = @_;

    my $get_index = sub {
        my $i = $args->{index};

        if ( $i !~ m{\A[01234]\z} )
        {
            Carp::confess('index must be in the range 0-4');
        }

        return $i;
    };

    my $clue_idx;
    my $type = $args->{type};

    if ( $type eq 'col' )
    {
        $clue_idx = 2 + $LEN + $get_index->();
    }
    elsif ( $type eq 'row' )
    {
        $clue_idx = 2 + $get_index->();
    }
    elsif ( $type eq 'diag' )
    {
        $clue_idx = 0;
    }
    elsif ( $type eq 'antidiag' )
    {
        $clue_idx = 1;
    }
    else
    {
        Carp::confess("Unknown type $type.");
    }

    return [ map { $letters[ $_ - 1 ] } @{ $self->_clues->[$clue_idx] } ];
}

=head2 my $string = $riddle->get_riddle_v1_string()

Returns the riddle version 1 string (without the header). See the documentation
of L<Games::ABC_Path::Solver::Board> for explanation.

=cut

sub get_riddle_v1_string
{
    my ($self) = @_;

    my $s = ( ( ' ' x 7 ) . "\n" ) x 7;

    substr( $s, ( $self->_A_pos->y + 1 ) * 8 + $self->_A_pos->x + 1, 1 ) = 'A';

    my $clues = $self->_clues();
    foreach my $clue_idx ( 0 .. $NUM_CLUES - 1 )
    {
        my @pos =
              ( $clue_idx == 0 ) ? ( [ 0, 0 ], [ 6, 6 ] )
            : ( $clue_idx == 1 ) ? ( [ 0, 6 ], [ 6, 0 ] )
            : ( $clue_idx < ( 2 + 5 ) )
            ? ( [ 1 + $clue_idx - (2), 0 ], [ 1 + $clue_idx - (2), 6 ] )
            : (
            [ 0, 1 + $clue_idx - ( 2 + 5 ) ],
            [ 6, 1 + $clue_idx - ( 2 + 5 ) ]
            );

        foreach my $i ( 0 .. 1 )
        {
            substr( $s, $pos[$i][0] * 8 + $pos[$i][1], 1 ) =
                $letters[ $clues->[$clue_idx]->[$i] - 1 ];
        }
    }

    return $s;
}

=head2 my $string = $riddle->get_final_layout()

Returns the final layout as a L<Games::ABC_Path::Generator::FinalLayoutObj> .

=cut

sub get_final_layout
{
    my ($self) = @_;

    return $self->_solution;
}

=head2 my $string = $riddle->get_final_layout_as_string({%args})

Returns the final layout as a string. %args is included for future extension.

=cut

sub get_final_layout_as_string
{
    my ( $self, $args ) = @_;

    return $self->_solution->as_string($args);
}

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=cut

1;    # End of Games::ABC_Path::Generator
