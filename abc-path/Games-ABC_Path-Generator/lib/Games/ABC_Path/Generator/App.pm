package Games::ABC_Path::Generator::App;

use 5.006;
use strict;
use warnings;

use Pod::Usage qw(pod2usage);

use parent 'Games::ABC_Path::Generator::Base';

use Getopt::Long qw(GetOptionsFromArray);

use Games::ABC_Path::Generator;

=head1 NAME

Games::ABC_Path::Generator::App - command line application for the ABC Path generator.

=head1 SYNOPSIS

    use Games::ABC_Path::Generator::App;

    my $app = Games::ABC_Path::Generator::App->new({ argv => \@ARGV, },);
    $app->run();

=head1 SUBROUTINES/METHODS

=head2 Games::ABC_Path::Generator::App->new({ argv => \@ARGV, },);

Initialize from @ARGV .

=cut

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

    $self->_argv( $args->{argv} );

    return;
}

=head2 $app->run()

Runs the application.

=cut

sub run
{
    my ($self) = @_;

    my $seed;
    my $mode = 'riddle';
    my $man  = 0;
    my $help = 0;
    if (
        !GetOptionsFromArray(
            $self->_argv(),
            'seed=i' => \$seed,
            'mode=s' => \$mode,
            'help|h' => \$help,
            man      => \$man,
        )
        )
    {
        pod2usage(2);
    }

    if ($help)
    {
        pod2usage(1);
    }
    elsif ($man)
    {
        pod2usage( -verbose => 2 );
    }
    elsif ( !defined($seed) )
    {
        die "Seed not specified! See --help.";
    }
    else
    {
        my $gen = Games::ABC_Path::Generator->new( { seed => $seed, } );

        if ( $mode eq 'final' )
        {
            print $gen->calc_final_layout()->as_string( {} );
        }
        elsif ( $mode eq 'riddle' )
        {
            my $riddle        = $gen->calc_riddle();
            my $riddle_string = $riddle->get_riddle_v1_string;

            print sprintf( "ABC Path Solver Layout Version 1:\n%s",
                $riddle_string, );
        }

    }
    return;
}

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=cut

1;    # End of Games::ABC_Path::Generator::App
