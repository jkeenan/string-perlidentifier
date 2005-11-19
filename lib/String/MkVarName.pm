package String::MkVarName;
use 5.006001;
use strict;
use base qw(Exporter);
our @EXPORT_OK = qw{ make_varname };
our $VERSION = "0.02";
use Carp;

our @lower =  qw(a b c d e f g h i j k l m n o p q r s t u v w x y z);
our @upper = map { uc($_) } @lower;
our @eligibles = (@upper, @lower, q{_});
our @chars = (@eligibles, 0..9);

our %forbidden = ();
our $MIN = 3;
our $MAX = 20;
our $DEFAULT = 10;

sub make_varname {
    my $length;
    if (defined $_[0] and ref($_[0]) eq 'HASH') {
        my $argsref = shift;
        if (defined $argsref->{min}) {
            croak "Minimum must be all numerals: $!"
                unless $argsref->{min} =~ /^\d+$/;
            croak "Cannot set minimum length less than 2: $!"
                unless $argsref->{min} >= 2;
            $MIN = $argsref->{min};
        }
        if (defined $argsref->{max}) {
            croak "Maximum must be all numerals: $!"
                unless $argsref->{max} =~ /^\d+$/;
            croak "Cannot set maximum length less than 3: $!"
                unless $argsref->{max} >= 3;
            $MAX = $argsref->{max};
        }
        if (defined $argsref->{default}) {
            croak "Default must be all numerals: $!"
                unless $argsref->{default} =~ /^\d+$/;
            $DEFAULT = $argsref->{default};
        }
        if ( (defined $argsref->{min}) &&
             (defined $argsref->{max}) ) {
            croak "Minimum must be <= Maximum: $!"
                if $argsref->{min} >= $argsref->{max};
        }
    } else {
        $length = shift;
    }
    $length = $DEFAULT if ! defined $length;
    $length = $MIN if $length < $MIN;
    $length = $MAX if $length > $MAX;
    my $varname;
    MKVAR: {
        $varname = $eligibles[int(rand(@eligibles))];
        $varname .= $chars[int(rand(@chars))] for (1 .. ($length - 1));
        next MKVAR if $forbidden{$varname};
    }
    return $varname;
}

#################### DOCUMENTATION ###################

=head1 NAME

String::MkVarName - Generate a random name for a Perl variable

=head1 VERSION

This document refers to version 0.02, released November 17, 2005.

=head1 SYNOPSIS

    use String::MkVarName qw( make_varname );

    $varname = make_varname();      # defaults to 10 characters

or

    $varname = make_varname(12);    # min: 3    max: 20

=head1 DESCRIPTION

This module exports one subroutine, C<make_varname()>, which returns a string
composed of random characters that qualifies to be the name for a Perl
variable.  The characters are limited to upper- and lower-case letters in the 
English alphabet, the numerals from 0 through 9 and the underscore character.
The first character may not be a numeral.

By default, C<make_varname()> returns a string of 10 characters, but if a
numerical argument between 3 and 20 is passed to it, a string of that length
will be returned.  Arguments smaller than 3 are rounded up to 3; arguments
greater than 20 are rounded down to 20.

=head1 TODO

Ideally, before returning a string to be used as the name of a Perl variable,
the function should check that no variable of that name is currently in scope.
This would require checking all package variables, lexical variables and the
Perl special variables.  It doesn't do that yet.

=head1 AUTHOR

	James E Keenan
	CPAN ID: JKEENAN
	jkeenan@cpan.org
	http://search.cpan.org/~jkeenan

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;


