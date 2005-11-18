# t/02_specified.t - tests for specified length
use Test::More tests => 55;
use strict;
use warnings;

BEGIN { use_ok( 'String::MkVarName', qw{ make_varname } ); }
our (%eligibles, %chars);
require "t/eligible_chars";

specified_length_tests($_) for (3..20);

sub specified_length_tests {
    my $specified = shift;
    my $varname = make_varname($specified);
    my $length = length($varname);
    is( $length, $specified, "length of string is $specified as specified");
    
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

