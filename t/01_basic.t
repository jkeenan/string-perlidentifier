# t/01_basic.t - four basic tests
use Test::More 
tests => 41;
# qw(no_plan);
use strict;
use warnings;

BEGIN { use_ok( 'String::MkVarName', qw{ make_varname } ); }
our (%eligibles, %chars);
require "t/eligible_chars";

four_basic_tests() for (1..10);

sub four_basic_tests {
    my $varname = make_varname();
    my $length = length($varname);
    ok( ($length >= 3), "length meets or exceeds minimum");
    ok( ($length <= 20), "length meets or is less than maximum");
    
    my @els = split(q{}, $varname);
    ok( $eligibles{$els[0]},
        "first character in variable is letter or underscore");
    my @balance = @els[1..$#els];
    my $factor = 0;
    while ( defined ( my $k = shift @balance ) ) {
        $factor = 1 if ! $chars{$k};
        last if $factor;
    }
    ok(! $factor, "characters 2..last are letters, numerals or underscore");
}

