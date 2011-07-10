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
    my ($self, $int) = @_;

    return (($int / $LEN), ($int % $LEN));
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

{
my @get_next_cells_lookup =
(
    map {
        my ($sy, $sx) = __PACKAGE__->_to_xy($_);
        [ map {
            my ($y,$x) = ($sy+$_->[$Y], $sx+$_->[$X]);
            (
                (($x >= 0) && ($x < $LEN) && ($y >= 0) && ($y < $LEN))
                ? (__PACKAGE__->_xy_to_int([$y,$x])) : ()
            )
            }
            ([-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1])
        ]
    } (0 .. $BOARD_SIZE - 1)
);

sub _get_next_cells
{
    my ($self, $l, $init_idx) = @_;

    return [ grep { vec($l, $_, 8) == 0 }
        @{$get_next_cells_lookup[$init_idx]}
    ];
}

}


sub _add_next_state
{
    my ($self, $stack, $l, $cell_int) = @_;

    vec($l, $cell_int, 8) = 1+@$stack;
    my $cells = $self->_get_next_cells($l, $cell_int);
    $self->_fisher_yates_shuffle($cells);

    push @$stack, [$l, $cells];

    return;
}

sub _get_num_connected
{
    my ($self, $l) = @_;

    my @connectivity_stack = (index($l, "\0"));

    my %connected;
    while (@connectivity_stack)
    {
        my $int = pop(@connectivity_stack);
        if (!$connected{$int}++)
        {
            push @connectivity_stack, 
            (grep { !exists($connected{$_}) } 
                @{ $self->_get_next_cells($l, $int) }
            );
        }
    }

    return scalar keys %connected;
}

use List::Util qw(first);

sub generate
{
    my $self = shift;

    my @dfs_stack;
    $self->_add_next_state(\@dfs_stack, '', $self->{rand}->range_rand($BOARD_SIZE));

    DFS:
    while (@dfs_stack)
    {
        my ($l, $last_cells) = @{$dfs_stack[-1]};

        if (@dfs_stack == $BOARD_SIZE)
        {
            return $l;
        }

        # TODO : remove these traces later.
        # print "Depth = " . scalar(@dfs_stack) . "\n";
        # print "Last state = " . Dumper($last_state) . "\n";
        # print "Layout = \n" . $self->get_layout_as_string($last_state->{layout}) . "\n";

        my $next_idx = shift(@$last_cells);

        if ( ( ! defined($next_idx) )
                or
            ($self->_get_num_connected($l) != 
                ($BOARD_SIZE - scalar(@dfs_stack))
            )
        )
        {
            pop(@dfs_stack);
        }
        else
        {
            $self->_add_next_state(\@dfs_stack, $l, $next_idx);
        }
    }

    die "Not found!";
}

sub get_layout_as_string
{
    my ($self, $l) = @_;

    my $render_row = sub {
        my $y = shift;

        return join(" | ", 
            map { my $x = $_; my $v = vec($l, $self->_xy_to_int([$y,$x]), 8);
            $v ? $letters[$v-1] : '*' } (0 .. $LEN - 1));
    };

    return join('', map { $render_row->($_) . "\n" } (0 .. $LEN-1));
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