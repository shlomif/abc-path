use 5.006;

use strict;
use warnings;

use lib './inc';

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    module_name         => 'Games::ABC_Path::Generator',
    license             => 'mit',
    dist_author         => q{Shlomi Fish <shlomif@cpan.org>},
    dist_version_from   => 'lib/Games/ABC_Path/Generator.pm',
    configure_requires => {
        'Module::Build' => '0.36',
    },
    build_requires => {
        'Test::Differences' => 0,
        'Test::More' => 0,
    },
    requires => {
        'Class::XSAccessor' => 0,
        'Games::ABC_Path::Solver::Base' => 0,
        'Games::ABC_Path::Solver::Board' => '0.1.0',
        'integer' => 0,
        'perl' => 5.006,
        'strict' => 0,
        'warnings' => 0,
    },
    add_to_cleanup      => [ 'Games-ABC_Path-Generator-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
