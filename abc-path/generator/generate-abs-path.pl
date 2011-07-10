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

sub _xy_to_int
{
    my ($self, $xy) = @_;

    return $xy->[$Y] * $LEN + $xy->[$X];
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

sub _get_moves
{
    my ($self, $pos, $xy) = @_;

    my $in_range = sub { my $i = shift; return (($i >= 0) && ($i < $LEN)); };

    return
    [ 
        grep {
        my $m = $_;
        my $applied_x = $xy->[$X] + $m->[$X];
        my $applied_y = $xy->[$Y] + $m->[$Y];

        $in_range->($applied_x) && $in_range->($applied_y) &&
        (!defined($pos->{layout}->[$applied_y]->[$applied_x]))
        } ([-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1])
    ];
}

sub _fill_available_moves
{
    my ($self, $pos) = @_;


    my $moves = $self->_get_moves($pos, $pos->{last_pos});
    $self->_fisher_yates_shuffle($moves);
    $pos->{moves} = $moves;

    return;
}

use List::Util qw(first);

sub _apply_move_to_pos
{
    my ($self, $pos, $move) = @_;

    return [$pos->[$Y] + $move->[$Y], $pos->[$X] + $move->[$X]];
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
        # print "Depth = " . scalar(@dfs_stack) . "\n";
        # print "Last state = " . Dumper($last_state) . "\n";

        {
            my $l = $last_state->{layout};

            my $first_xy = first { my ($y,$x) = $self->_to_xy($_); 
                !defined($l->[$y]->[$x]) } (0 .. $BOARD_SIZE-1);

            my @connectivity_stack = ($first_xy);

            my %connected;
            while (@connectivity_stack)
            {
                my $int = pop(@connectivity_stack);
                $connected{$int} = 1;

                my $xy = [$self->_to_xy($int)];

                my $moves =
                    $self->_get_moves($last_state, $xy );

                foreach my $m (@$moves)
                {
                    my $next_xy =
                        $self->_apply_move_to_pos($xy, $m);

                    my $next_int = $self->_xy_to_int($next_xy);
                    if (!exists($connected{$next_int}))
                    {
                        push @connectivity_stack, $next_int;
                    }
                }
            }

            if (
                (scalar(keys(%connected)) != $BOARD_SIZE - scalar(@dfs_stack))
            )
            {
                pop(@dfs_stack);
                next DFS;
            }
        }

        my $next_move = shift(@{$last_state->{moves}});

        if (!defined($next_move))
        {
            pop(@dfs_stack);
            next DFS;
        }

        my $next_pos = $self->_apply_move_to_pos(
            $last_state->{last_pos}, $next_move
        );

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

sub get_layout_as_string
{
    my ($self, $l) = @_;

    my $render_row = sub {
        my $row = shift;

        return join(" | ", map { defined($_) ? $_ : '*' } @$row);
    };

    return join('', map { $render_row->($_) . "\n" } @$l);
}

package main;

use strict;
use warnings;

use Getopt::Long;

my $seed = 24;

if (!GetOptions(
        'seed=i' => \$seed,
    ))
{
    die "Could not get options for program!";
}

my $gen = Games::ABC_Path::Generator->new({ seed => $seed, });

print $gen->get_layout_as_string($gen->generate());
