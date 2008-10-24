use inc::Module::Install;

name     'DBIx-Class-InflateColumn-Object-Enum';
all_from 'lib/DBIx/Class/InflateColumn/Object/Enum.pm';
author   'Jason M. Mills <jmmills at cpan.org>';

requires 'DBIx::Class::Schema';
requires 'self';
requires 'Object::Enum';

build_requires 'Test::More';
build_requires 'DBICx::TestDatabase';

auto_manifest;
auto_install;

WriteAll;

