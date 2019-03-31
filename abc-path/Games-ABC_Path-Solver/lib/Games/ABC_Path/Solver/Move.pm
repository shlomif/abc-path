package Games::ABC_Path::Solver::Move;

use warnings;
use strict;

=head1 NAME

Games::ABC_Path::Solver::Move - an ABC Path move.

=head1 SYNOPSIS

    use Games::ABC_Path::Solver::Move;

    my $foo = Games::ABC_Path::Solver::Move->new();

=head1 FUNCTIONS

=head2 new

The constructor.

=cut

use parent 'Games::ABC_Path::Solver::Base';

=head2 get_text()

A method that retrieves the text of the move.

=cut

sub get_text
{
    my $self = shift;

    my $text = $self->_format;

    $text =~ s/%\((\w+)\)\{(\w+)\}/
        $self->_expand_format($1,$2)
        /ge;

    return $text;
}

sub _depth
{
    my $self = shift;

    if (@_)
    {
        $self->{_depth} = shift;
    }

    return $self->{_depth};
}

=head2 get_depth()

A method that retrieves the solving recursion depth of the move.

=cut

sub get_depth
{
    my ($self) = @_;

    return $self->_depth();
}

sub _init
{
    my ( $self, $args ) = @_;

    $self->{_text} = $args->{text};
    $self->_depth( $args->{depth} || 0 );
    $self->{_vars} = ( $args->{vars} || {} );

    return;
}

=head2 bump

Creates a new identical move with an incremented depth.

=cut

sub bump
{
    my ($self) = @_;

    return ref($self)->new(
        {
            text  => $self->get_text(),
            depth => ( $self->get_depth + 1 ),
            vars  => { %{ $self->{_vars} }, },
        }
    );
}

=head2 $self->get_var($name)

This method returns the raw, unformatted value of the move's variable (or its
parameter) called $name. Each move class contains several parameters that can
be accessed programatically.

=cut

sub get_var
{
    my ( $self, $name ) = @_;

    return $self->{_vars}->{$name};
}

# TODO : duplicate code with ::Board
my @letters = (qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y));

sub _expand_format
{
    my ( $self, $name, $type ) = @_;

    my $value = $self->get_var($name);

    if ( $type eq "letter" )
    {
        return $letters[$value];
    }
    elsif ( $type eq "coords" )
    {
        return sprintf( "(%d,%d)", $value->x() + 1, $value->y() + 1 );
    }
    else
    {
        die "Unknown format type '$type'!";
    }
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-abc_path-solver at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-ABC_Path-Solver>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::ABC_Path::Solver::Move


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

1;    # End of Games::ABC_Path::Solver::Move
