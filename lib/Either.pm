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
    my $code = shift;

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

=encoding utf8
=head1 NAME

Either - A simple and lightweight implementation error handling library for Perl,
inspired in the Either type.

=head1 SYNOPSIS

    use Either qw(either);

    my $meaning =  either { 80 / $divisor }->then(sub { $_ + 2 });

    say "The life meaning is " . $meaning->value if $meaning->is_valid;
    warn "Life has no meaning" if not $meaning->is_valid;

=head1 DESCRIPTION

The purpose of the C<< either >> function is to let you focus in the happy path
and provide a nice way to treat failures without filling the code
with C<< eval >>s and C<< if >>s that always serve almost the same purpose.

Supose you have a computation that can fail depending on some condition.
For the sake of simplicity consider the following code

    sub compute_meaning {
        my $divisor = shift;
        return 2 + 80 / $divisor;
    };

that will fail when called with a zero argument.

Following the style of the L<Railway Oriented Programming|https://fsharpforfunandprofit.com/rop/>, you wrap the part
that could fail in a C<< either >> block and focus on programming the happy
path:

    sub compute_meaning {
        my $divisor = shift;
        return either { 80 / $divisor }
               ->then(sub { $_ + 2 });
    };

This way, the C<< compute_meaning >> function will never blow, even when
passed in a zero argument and the computation doesn't make sense. The caller
can check that the computation succeeded by asking the C<< either >> result
object.

When the computation succeeds, the C<< value >> property contains
the computation result

    my $meaning = compute_meaning(2);
    say "The life meaning is " $meaning->value if $meaning->is_valid;

and when the computation fails, you can also inform the user or decide how to
proceed, by inspecting the C<< failure >> value, which will contain the captured
error.

    my $meaning = compute_meaning(0);
    warn "Life has no meaning: " . $meaning->failure if not $meaning->is_valid;


=head2 Chaining

The real usability gain of using C<< either >> occurs when you have a recipe
that comprises several things to do and you need to stop at the first step
that fails.

That is, you need to chain or compose several functions that
in the happy path would be executed one after another but in the real path, you
would have to check for any of them if had failed or not and proceed with
the next or stop and report the errors.

With C<< either >> you can leverage the checking to the library and just program
the happy path functions and chain them with the C<< then >> method:

  use Either;

  my $res = either { 40 / $something }
    ->then(sub { $_ / 2 })
    ->then(sub { $_ * 4 })
    ->then(sub { $_ + 2 });

You can always know if the computation has succed by inspecting the either,

    say $res->value if $res->is_valid;

or treat the error otherwise

    warn $res->failure if not $res->is_valid;

The computation will short-circuit and return with the first error occurred,
no matter how many chained functions remain after the failing step.

=head2 On Either types and then

This module does not implement the Either type in Perl. The Haskell, F#, ML and
other strongly typed functional programming languages have Either types. This
is not a generic type like Haskell's C<Either a b>.

On those PL you have a strong type system and generic programming facilities that
allow you to generalize operations into higher abstractions. In particular, you
can operate in elevated (monadic) types as if they where first class values and the
languages provide tools (generic functions and operators) that allow you to
compose those operations by somehow overloading composition.

When adopting an Either type to implement ROP in those languages, you normally use
the C< >=> > operator to overload composition. Actually, you use it to compose
functions of the type

  >=> :: (a -> Either b e) -> (b -> Either c e) -> (a -> Either c e)

This library just uses a wrapper object (the Either instance) that has a method C<then> to somehow
compose other operations. This is a much less flexible approach but it works and is easy to understand.
The two leaves of the type are accessible via the instance's C<value> and C<failure> getters.

The only confusion might be that it ressembles the C<then> function of a promise or future. This is not
exactly the same. Just keep that in mind.

=head2 USAGE

You can find more usage examples in the tests C<t/Then.t>. For examples of
how to use inside Moose C<t/Example.t>

=head2 Running tests

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
