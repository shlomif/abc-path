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
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Class::XSAccessor' => 0,
        'integer' => 0,
        'perl' => 5.006,
        'strict' => 0,
        'warnings' => 0,
    },
    add_to_cleanup      => [ 'Games-ABC_Path-Generator-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
