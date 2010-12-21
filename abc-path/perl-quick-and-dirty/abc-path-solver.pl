#!/usr/bin/perl

use strict;
use warnings;

use Carp;

my $ABCP_VERDICT_NO = 0;
my $ABCP_VERDICT_MAYBE = 1;
my $ABCP_VERDICT_YES = 2;

# This will handle 25*25 2-bit cells and the $ABCP_VERDICT_MAYBE / etc.
# verdicts above.
my $verdicts_matrix = '';

sub get_verdict
{
    my ($letter, $x, $y) = @_;

    if (($letter < 0) or ($letter >= 25))
    {
        confess "Letter $letter out of range.";
    }

    if (($x < 0) or ($x >= 5))
    {
        confess "X $x out of range.";
    }

    if (($y < 0) or ($y >= 5))
    {
        confess "X $y out of range.";
    }


    return vec($verdicts_matrix, $letter*25+$y*5+$x, 2);
}

sub set_verdict
{
    my ($letter, $x, $y, $verdict) = @_;

    if (($letter < 0) or ($letter >= 25))
    {
        confess "Letter $letter out of range.";
    }

    if (($x < 0) or ($x >= 5))
    {
        confess "X $x out of range.";
    }

    if (($y < 0) or ($y >= 5))
    {
        confess "X $y out of range.";
    }

    if (not
        (($verdict == $ABCP_VERDICT_NO)
        || ($verdict == $ABCP_VERDICT_MAYBE)
        || ($verdict == $ABCP_VERDICT_YES))
    )
    {
        confess "Invalid verdict $verdict .";
    }

    vec($verdicts_matrix, $letter*25+$y*5+$x, 2) = $verdict;

    return;
}

my @letters = (qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y));

# Input the board.

my $board_fn = shift(@ARGV);

open my $in_fh, "<", $board_fn
    or die "Cannot open '$board_fn' - $!";

my $first_line = <$in_fh>;
chomp($first_line);

my $magic = 'ABC Path Solver Layout Version 1:';
if ($first_line !~ m{\A\Q$magic\E\s*\z})
{
    die "Can only process files whose first line is '$magic'!";
}

my $layout_string = '';
foreach my $line_idx (1 .. 7)
{
    chomp(my $line = <$in_fh>);
    $layout_string .= "$line\n";
}
close($in_fh);

# For debugging:
# print $layout_string;

my $letter_re = qr{[A-Y]};
my $letter_and_space_re = qr{[ A-Y]};
my $top_bottom_re = qr/^${letter_re}{7}\n/ms;
my $inner_re = qr/^${letter_re}${letter_and_space_re}{5}${letter_re}\n/ms;

if ($layout_string !~ m/\A${top_bottom_re}${inner_re}{5}${top_bottom_re}\z/ms)
{
    die "Invalid format. Should be Letter{7}\n(Letter{spaces or one letter}{5}Letter){5}\nLetter{7}";
}

{
    my %count_letters = (map { $_ => 0 } @letters);
    foreach my $letter ($layout_string =~ m{($letter_re)}g)
    {
        if ($count_letters{$letter}++)
        {
            die "Letter '$letter' encountered twice in the layout.";
        }
    }
}

my %letters_map = (map { $letters[$_] => $_ } (0 .. $#letters));
sub get_letter_numeric
{
    my $letter_ascii = shift;

    my $index = $letters_map{$letter_ascii};

    if (!defined ($index))
    {
        confess "Unknown letter '$letter_ascii'";
    }

    return $index;
}

# Now let's process the layout string and populate the verdicts table.

sub set_verdicts_for_letter_sets
{
    my ($letter_list, $maybe_list) = @_;

    my %cell_is_maybe =
        (map {; sprintf("%d,%d", @$maybe_list) => 1; } @$maybe_list);

    foreach my $letter_ascii (@$letter_list)
    {
        my $letter = get_letter_numeric($letter_ascii);
        foreach my $y (0 .. 4)
        {
            foreach my $x (0 .. 4)
            {
                set_verdict($letter, $x, $y,
                    ((exists $cell_is_maybe{"$x,$y"})
                        ? $ABCP_VERDICT_MAYBE
                        : $ABCP_VERDICT_NO
                    )
                );
            }
        }
    }
}

{
    my @major_diagonal_letters;

    $layout_string =~ m{\A(.)};

    push @major_diagonal_letters, $1;

    $layout_string =~ m{(.)\n\z};

    push @major_diagonal_letters, $1;

    set_verdicts_for_letter_sets(
        \@major_diagonal_letters, 
        [map { [$_,$_] } (0 .. 4)],
    )
}

{
    my @minor_diagonal_letters;

    $layout_string =~ m/\A${letter_re}*($letter_re)\n/ms;

    push @minor_diagonal_letters, $1;

    $layout_string =~ m{($letter_re*)\n\z}ms;

    push @minor_diagonal_letters, substr($1,0,1);

    set_verdicts_for_letter_sets(
        \@minor_diagonal_letters,
        [map { [$_, 4-$_] } (0 .. 4)]
    );
}

{
    my ($top_row) = ($layout_string =~ m/\A(${letter_re}*)\n/ms);
    my ($bottom_row) = ($layout_string =~ m/(${letter_re}*)\n\z/ms);

    foreach my $x (0 .. 4)
    {
        set_verdicts_for_letter_sets(
            [substr($top_row, $x+1, 1), substr($bottom_row, $x+1, 1),],
            [map { [$x,$_] } (0 .. 4)],
        );
    }
}

{
    my @rows = split(/\n/, $layout_string);

    foreach my $y (0 .. 4)
    {
        my $row = $rows[$y+1];
        set_verdicts_for_letter_sets(
            [substr($row, 0, 1), substr($row, -1),],
            [map { [$_,$y] } (0 .. 4)],
        );
    }
}
