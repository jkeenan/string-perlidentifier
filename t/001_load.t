# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'String::MkVarName' ); }

my $object = String::MkVarName->new ();
isa_ok ($object, 'String::MkVarName');


