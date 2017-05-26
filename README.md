# Perl-Either

This is a simple and lightweight implementation of the Either type in Perl.

Given the Perl mechanism for dealing with exceptions, `eval`, this
module tries to provide a way to organize the code without resorting
to n + 1 levels of evaling and spaghetti code.

It is inspired in the `Either a b` type of Haskell (but with `b` always an
error in the form of a scalar Perl string) or the ROP programming anyone
discovers when using F#.
