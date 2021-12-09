#!/usr/bin/env perl

use 5.014;
use strict;
use warnings;
use autodie;

sub do_system
{
    my ($args) = @_;

    my $cmd = $args->{cmd};
    print "Running [@$cmd]\n";
    if ( system(@$cmd) )
    {
        die "Running [@$cmd] failed!";
    }
}

my $IS_WIN = ( $^O eq "MSWin32" );
my $SEP    = $IS_WIN ? "\\"    : '/';
my $MAKE   = $IS_WIN ? 'gmake' : 'make';

my $cmake_gen;
if ($IS_WIN)
{
    $cmake_gen = 'MSYS Makefiles';
}
my $ACTION = shift @ARGV;

my @dzil_dirs = (
    'abc-path/Games-ABC_Path-Generator',
    'abc-path/Games-ABC_Path-Solver',
    'abc-path/Math-RNG-Microsoft',
);

# my $TEMP_DEBUG = $IS_WIN;
my $TEMP_DEBUG = 0;
my $CPAN       = 'cpanm';
if ($TEMP_DEBUG)
{
    $CPAN .= " -n";
}
if ( $ACTION eq 'install_deps' )
{
    foreach my $d (@dzil_dirs)
    {
        do_system(
            {
                cmd => [
"cd $d && (dzil authordeps --missing | $CPAN) && (dzil listdeps --author --missing | $CPAN)"
                ]
            }
        );
    }
}
elsif ( $ACTION eq 'test' )
{
    if ( $TEMP_DEBUG and $IS_WIN )
    {
        foreach my $d ( 'Perl/modules/HTML-Latemp-News', )
        {
            use Path::Tiny qw/ cwd path /;
            my $cwd = cwd();
            chdir($d);
            do_system( { cmd => [ "dzil", "build", ] } );
            my $build = "HTML-Latemp-News-0.2.1";
            chdir($build);
            my $fn     = "lib/HTML/Latemp/News.pm";
            my $backup = "c:/News.pm-aristt.orig.orig";
            path($fn)->copy($backup);
            eval { do_system( { cmd => [ "tidyall", "-a", ] } ); };
            do_system(
                {
                    cmd => [ "diff", "-u", $backup, $fn, ],
                }
            );
            chdir($cwd);
        }
        exit(1);
    }

DZIL_DIRS:
    foreach my $d (@dzil_dirs)
    {
        # tidyall test is failing on Windows
        if ( $IS_WIN and ( $d =~ /Latemp-News\z/ ) )
        {
            next DZIL_DIRS;
        }
        do_system( { cmd => ["cd $d && (dzil smoke --release --author)"] } );
    }
}
else
{
    die "Unknown action command '$ACTION'!";
}
