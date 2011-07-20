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

use Games::ABC_Path::Solver::Board '0.1.0';

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
    my ($self, $deck) = @_;
    return unless @$deck; # must not be empty!

    my $r = $self->{'rand'};

    my $i = @$deck;
    while (--$i) {
        my $j = $r->range_rand($i+1);
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

sub calc_final_layout
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

my $NUM_CLUES = (2+5+5);

sub calc_riddle
{
    my ($self) = @_;

    my $layout = $self->calc_final_layout();

    my $A_pos = index($layout, chr(1));

    my %init_state = (pos_taken => '', 
        clues =>
        [ 
            map { +{ num_remaining => 5, } }
            (1 .. $NUM_CLUES),
        ]
    );

    my $mark = sub {
        my ($state, $pos) = @_;
        
        vec($state->{pos_taken}, $pos, 1) = 1;
        
        my ($y,$x) = $self->_to_xy($pos);
        foreach my $clue (
            (($y == $x) ? 0 : ()),
            (($y == (5-1)-$x) ? 1 : ()),
            (2+$y),
            ((2+5)+$x),
        )
        {
            $state->{clues}->[$clue]->{num_remaining}--;
        }
    };

    $mark->(\%init_state, $A_pos);

    my @dfs_stack = (\%init_state);

    DFS:
    while (@dfs_stack)
    {
        my $last_state = $dfs_stack[-1];

        if (! exists($last_state->{chosen_clue}))
        {
            my @clues =
            (
                sort {
                    ($a->[1]->{num_remaining} <=> $b->[1]->{num_remaining})
                        or
                    ($a->[0] <=> $b->[0])
                }
                grep { !exists($_->[1]->{cells}) }
                map { [$_, $last_state->{clues}->[$_]] }
                (0 .. $NUM_CLUES-1)
            );

            if (!@clues)
            {
                # Yay! We found a configuration.
                my $handle_clue = sub {
                    my @cells = @{shift->{cells}};
                    $self->_fisher_yates_shuffle(\@cells);
                    return [map { vec($layout, $_, 8) } @cells];
                };
                my $riddle =
                {
                    solution => $layout,
                    clues =>
                    [
                        map { $handle_clue->($_) } @{$last_state->{clues}}
                    ],
                    A_pos => [$self->_to_xy($A_pos)],
                };
                
                my $riddle_string = $self->_get_riddle_only_as_string($riddle);

                my $solver = 
                    Games::ABC_Path::Solver::Board->input_from_v1_string(
                        $riddle_string
                    );
                
                $solver->solve();

                if (@{$solver->get_successes_text_tables()} != 1)
                {
                    # The solution is ambiguous
                    pop(@dfs_stack);
                    next DFS;
                }
                else
                {
                    return $riddle;
                }
            }
            # Not enough for the clues there.
            if ($clues[0][1]->{num_remaining} < 2)
            {
                pop(@dfs_stack);
                next DFS;
            }

            my $clue_idx = $clues[0][0];

            $last_state->{chosen_clue} = $clue_idx;

            my @positions =
            (
                grep { !vec($last_state->{pos_taken}, $_, 1) } 
                (
                    map { $self->_xy_to_int($_) }
                    (($clue_idx == 0)
                        ? (map { [$_,$_] } (0 .. $LEN-1))
                        : ($clue_idx == 1)
                        ? (map { [$_,4-$_] } ( 0 .. $LEN-1))
                        : ($clue_idx < (2+5))
                        ? (map { [$clue_idx-2,$_] } (0 .. $LEN-1))
                        : (map { [$_, $clue_idx-(2+5)] } (0 .. $LEN-1))
                    )
                )
            );

            my @pairs;

            foreach my $first_idx (0 .. $#positions-1)
            {
                foreach my $second_idx ($first_idx+1 .. $#positions)
                {
                    push @pairs, [@positions[$first_idx, $second_idx]];
                }
            }

            $self->_fisher_yates_shuffle(\@pairs);

            $last_state->{pos_pairs} = \@pairs;
        }

        my $chosen_clue = $last_state->{chosen_clue};
        my $next_pair = shift(@{$last_state->{pos_pairs}});

        if (!defined($next_pair))
        {
            pop(@dfs_stack);
            next DFS;
        }

        my %new_state;
        $new_state{pos_taken} = $last_state->{pos_taken};
        $new_state{clues} = [map { +{ %{$_} } } @{$last_state->{clues}}];
        foreach my $pos (@$next_pair)
        {
            $mark->(\%new_state, $pos);
        }
        $new_state{clues}->[$chosen_clue]->{cells} = [@$next_pair];

        push @dfs_stack, (\%new_state);
    }
}

sub get_riddle_as_string
{
    my ($self,$riddle) = @_;

    my $layout_string = $self->get_layout_as_string($riddle->{solution});
    
    my $riddle_string = $self->_get_riddle_only_as_string($riddle);

    return <<"EOF";
ABC Path Solver Layout Version 1:
$riddle_string

Solution:
$layout_string
EOF
}

sub _get_riddle_only_as_string
{
    my ($self,$riddle) = @_;

    my $s = ((' ' x 7)."\n")x7;

    substr($s, ($riddle->{A_pos}->[$Y]+1) * 8 + $riddle->{A_pos}->[$X]+1, 1) = 'A';

    my $clues = $riddle->{clues};
    foreach my $clue_idx (0 .. $NUM_CLUES-1)
    {
        my @pos = 
            ($clue_idx == 0) ? ([0,0],[6,6]) 
            : ($clue_idx == 1) ? ([0,6],[6,0])
            : ($clue_idx < (2+5)) ? ([1+$clue_idx-(2), 0], [1+$clue_idx-(2), 6])
            : ([0, 1+$clue_idx-(2+5)], [6, 1+$clue_idx-(2+5)])
            ;

        foreach my $i (0 .. 1)
        {
            substr ($s, $pos[$i][0] * 8 + $pos[$i][1], 1)
                = $letters[$clues->[$clue_idx]->[$i] - 1];
        }
    }

    return $s;
}


package main;

use strict;
use warnings;

use Getopt::Long;

my $seed = 24;
my $mode = 'final';
if (!GetOptions(
        'seed=i' => \$seed,
        'mode=s' => \$mode,
    ))
{
    die "Could not get options for program!";
}

my $gen = Games::ABC_Path::Generator->new({ seed => $seed, });

if ($mode eq 'final')
{
    print $gen->get_layout_as_string($gen->calc_final_layout());
}
elsif ($mode eq 'riddle')
{
    print $gen->get_riddle_as_string($gen->calc_riddle());
}
