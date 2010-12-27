use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Games::ABC_Path::Solver::Base',
    AUTHOR              => q{Shlomi Fish <shlomif@cpan.org>},
    VERSION_FROM        => 'lib/Games/ABC_Path/Solver/Base.pm',
    ABSTRACT_FROM       => 'lib/Games/ABC_Path/Solver/Base.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'mit')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Games-ABC_Path-Solver-*' },
);
