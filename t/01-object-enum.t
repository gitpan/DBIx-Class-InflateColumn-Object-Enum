use Test::More tests => 10;

BEGIN {
	use lib 't/lib';
	use_ok( 'DBICx::TestDatabase');
	use_ok( 'TestDB' );
	
}

my $db = new DBICx::TestDatabase('TestDB');

ok(ref($db) eq 'TestDB','Testing database looks good');

my $rs = $db->resultset('Test')->create({
	name => '02-object-enum.t',
	color => ''
});

ok(defined($rs),'Got our created ResultSet row');

ok(ref($rs->color) =~ /^Object::Enum::/,'Column is properly referenced');

ok($rs->color->can('set_red'),'Column has correct set method');

$rs->color->set_red;

ok($rs->color->is_red,'Column set worked');

ok(!$rs->color->is_green,'Boolean accessors worked');

ok($rs->color->value eq 'red','Value accessor worked');

$rs->color->unset;

ok(!defined($rs->color->value),'Unset worked')