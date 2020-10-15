package Games::ABC_Path::Solver::App;

use warnings;
use strict;

=head1 NAME

Games::ABC_Path::Solver::App - a class wrapping a command line app for
solving ABC Path

=head1 SYNOPSIS

    #!/usr/bin/perl

    use strict;
    use warnings;

    use Games::ABC_Path::Solver::App;

    Games::ABC_Path::Solver::App->new({argv => \@ARGV, })->run;

=head1 FUNCTIONS

=head2 new

The constructor. Accepts a hash ref of named arguments. Currently only C<'argv'>
which should point to an array ref of command-line arguments.

=head2 run

Run the application based on the arguments in the constructor.

=cut

use parent 'Games::ABC_Path::Solver::Base';

use Getopt::Long qw/ GetOptionsFromArray /;
use Pod::Usage qw/ pod2usage /;

use Games::ABC_Path::Solver::Board ();

sub _argv
{
    my $self = shift;

    if (@_)
    {
        $self->{_argv} = shift;
    }

    return $self->{_argv};
}

sub _init
{
    my ( $self, $args ) = @_;

    $self->_argv( [ @{ $args->{argv} } ] );

    return;
}

sub run
{
    my $self = shift;

    my $man          = 0;
    my $help         = 0;
    my $gen_template = 0;
    GetOptionsFromArray(
        $self->_argv,
        'help|h'          => \$help,
        man               => \$man,
        'gen-v1-template' => \$gen_template,
    ) or pod2usage(2);

    if ($help)
    {
        pod2usage(1);
    }
    elsif ($man)
    {
        pod2usage( -verbose => 2 );
    }
    elsif ($gen_template)
    {
        print <<'EOF';
ABC Path Solver Layout Version 1:
???????
?     ?
?     ?
?     ?
?   A ?
?     ?
???????
EOF
    }
    else
    {
        my $board_fn = shift( @{ $self->_argv } );

        if ( !defined($board_fn) )
        {
            die
"Filename not specified - usage: abc-path-solver.pl [filename]!";
        }

        my $solver = Games::ABC_Path::Solver::Board->input_from_file($board_fn);

        # Now let's do a neighbourhood inferring of the board.

        $solver->solve;

        foreach my $move ( @{ $solver->get_moves } )
        {
            print +( ' => ' x $move->get_depth() ), $move->get_text(), "\n";
        }

        print @{ $solver->get_successes_text_tables };
    }

    exit(0);
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>


=head1 SEE ALSO

L<Games::ABC_Path::Solver> , L<Games::ABC_Path::Solver::Board> .

=cut

1;    # End of Games::ABC_Path::Solver::App
