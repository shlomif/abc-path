#!/usr/bin/perl

use strict;
use warnings;

package Games::ABC_Path::MicrosoftRand;

use strict;
use warnings;

use integer;

use Class::XSAccessor {
    constructor => 'new',
    accessors => [qw(seed)],
};

sub rand
{
    my $self = shift;
    $self->seed(($self->seed() * 214013 + 2531011) & (0x7FFF_FFFF));
    return (($self->seed >> 16) & 0x7fff);
}

sub range_rand
{
    my ($self, $max) = @_;

    return ($self->rand() % $max);
}

package Games::ABC_Path::Generator;

use strict;
use warnings;

use base 'Games::ABC_Path::Solver::Base';

use Data::Dumper;

sub _init
{
    my $self = shift;
    my $args = shift;

    $self->{seed} = $args->{seed};

    $self->{rand} = Games::ABC_Path::MicrosoftRand->new(seed => $self->{seed});

    return;
}

my $LEN = 5;
my $BOARD_SIZE = $LEN*$LEN;
my $Y = 0;
my $X = 1;

sub _to_xy
{
    my ($self, $pos) = @_;

    return (($pos / $LEN), ($pos % $LEN));
}

my @letters = ('A' .. 'Y');

sub _fisher_yates_shuffle {
    my $self = shift;
    my $deck = shift;  # $deck is a reference to an array
    return unless @$deck; # must not be empty!

    my $i = @$deck;
    while (--$i) {
        my $j = $self->{'rand'}->range_rand($i+1);
        @$deck[$i,$j] = @$deck[$j,$i];
    }

    return;
}

sub _fill_available_moves
{
    my ($self, $pos) = @_;

    my $in_range = sub { my $i = shift; return (($i >= 0) && ($i < $LEN)); };

    my @moves = (grep {
        my $m = $_;
        my $applied_x = $pos->{last_pos}->[$X] + $m->[$X];
        my $applied_y = $pos->{last_pos}->[$Y] + $m->[$Y];
        
        $in_range->($applied_x) && $in_range->($applied_y) &&
        (!defined($pos->{layout}->[$applied_y]->[$applied_x]))
    } ([-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1])
    );
    
    $self->_fisher_yates_shuffle(\@moves);
    $pos->{moves} = \@moves;

    return;
}

sub generate
{
    my $self = shift;

    my @initial_cell = $self->_to_xy($self->{rand}->range_rand($BOARD_SIZE));
    my $initial_position =
    { layout => [map { [] } (0 .. $LEN-1)], last_pos => [@initial_cell]}
    ;

    $initial_position->{layout}->[$initial_cell[$Y]]->[$initial_cell[$X]] =
        $letters[0];

    $self->_fill_available_moves($initial_position);
    
    my @dfs_stack = ($initial_position);

    DFS:
    while (@dfs_stack)
    {
        if (@dfs_stack == $BOARD_SIZE)
        {
            return $dfs_stack[-1]->{layout};
        }

        my $last_state = $dfs_stack[-1];

        # TODO : remove these traces later.
        print "Depth = " . scalar(@dfs_stack) . "\n";
        print "Last state = " . Dumper($last_state) . "\n";


        my $next_move = shift(@{$last_state->{moves}});

        if (!defined($next_move))
        {
            pop(@dfs_stack);
            next DFS;
        }

        my $next_pos =
        [
            map
            { 
                $last_state->{last_pos}->[$_] + $next_move->[$_] 
            }
            (0 .. $#$next_move)
        ];

        my $next_state =
        {
            layout => [ map { [@{$_}] } @{ $last_state->{layout} } ],
            last_pos => $next_pos,
        };

        $next_state->{layout}->[$next_pos->[$Y]]->[$next_pos->[$X]] =
            $letters[scalar @dfs_stack];

        $self->_fill_available_moves($next_state);

        push @dfs_stack, $next_state;
    }

    die "Not found!";
}

package main;

use strict;
use warnings;

use Data::Dumper;

my $gen = Games::ABC_Path::Generator->new({ seed => 24 });

print Dumper($gen->generate());
