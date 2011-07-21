use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Games::ABC_Path::Generator',
    license             => 'mit',
    dist_author         => q{Shlomi Fish <shlomif@cpan.org>},
    dist_version_from   => 'lib/Games/ABC_Path/Generator.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Games-ABC_Path-Generator-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
