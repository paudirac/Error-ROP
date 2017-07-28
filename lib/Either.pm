package Either;
use Either::Imp;
use Exporter qw/import/;

our @EXPORT_OK = qw/success failure either bind/;
our $VERSION = '0.01';

sub success {
    return Either::Imp->new(value => shift);
}

sub failure {
    return Either::Imp->new(failure => shift);
}

sub either (&) {
    my $code = \&{shift @_};

    my $res = eval {
        $code->(@_);
    };
    return failure($@) if $@;
    return success($res);
}

# Either a -> (a -> Either b) -> Either b
sub bind {
    my $either = shift @_;
    my $fn = \&{shift @_};
    return $either->is_valid ? either { $fn->($either->value) } : $either;
}

1;

=head1 NAME

Either - A simple and lightweight implementation of the Either type in Perl.

=head1 SYNOPSIS

Use the `either` function as a substitute of C<eval> and then chain your 
calls with C<then>, like in:

  use Either;

  my $res = either { 40 / 0 };
  my $res2 = $res
    ->then("Can't divide" => sub { $_ / 2 })
    ->then("Can't multiply" => sub { $_ * 4 })
    ->then("Can't sum" => sub { $_ + 2 });

=head1 DESCRIPTION

This is a simple and lightweight implementation of the Either type in Perl.

Given the Perl mechanism for dealing with exceptions, C<eval>, this
module tries to provide a way to organize the code without resorting
to n + 1 levels of evaling and spaghetti code.

It is inspired in the C<Either a b> type of Haskell (but with C<b> always an
error in the form of a scalar Perl string) or the ROP programming anyone
discovers when using F#.

=head1 USAGE

You can find more usage examples in the tests C<t/Then.t>. For examples of
how to use inside Moose C<t/Example.t>


=head1 Running tests

A C<Dockerfile> is provided in order to run the tests without needing
any perl in your system. Just run:

  $ make -f Makefile.docker test

This should construct an image with the necessary dependencies, copy
the source into the image and run the tests.

=head1 AUTHOR

    Pau Cervera i Badia
    CAPSiDE
    pau.cervera@capside.com

=head1 BUGS and SOURCE

The source code is located here: L<https://github.com/paudirac/Perl-Either>

Please report bugs to: L<https://github.com/paudirac/Perl-Either/issues>

=head1 COPYRIGHT and LICENSE

Copyright (c) 2017 by CAPSiDE

This code is distributed under the Apache 2 License. The full text of the license can be found in the LICENSE file included with this module.

=cut
