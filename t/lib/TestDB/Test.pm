package TestDB::Test;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/
    InflateColumn::Object::Enum
    PK::Auto
    Core
/);
__PACKAGE__->table('test');
__PACKAGE__->add_columns(
    id => {
        data_type => 'number',
        is_auto_increment => 1,
        is_nullable => 0
    },
    name => {
        data_type => 'varchar',
        size => '64',
        is_nullable => 0
    },
    color => {
        data_type => 'varchar',
        is_nullable => 1,
        size => '64',
        is_enum => 1,
        values => [qw/red green blue]/]
    }
);
__PACKAGE__->set_primary_key('id');

1;