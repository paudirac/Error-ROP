# NAME

Either - A simple and lightweight implementation of the Either type in Perl.

# SYNOPSIS

Use the \`either\` function as a substitute of `eval` and then chain your 
calls with `then`, like in:

    use Either;

    my $res = either { 40 / 0 };
    my $res2 = $res
      ->then("Can't divide" => sub { $_ / 2 })
      ->then("Can't multiply" => sub { $_ * 4 })
      ->then("Can't sum" => sub { $_ + 2 });

# DESCRIPTION

This is a simple and lightweight implementation of the Either type in Perl.

Given the Perl mechanism for dealing with exceptions, `eval`, this
module tries to provide a way to organize the code without resorting
to n + 1 levels of evaling and spaghetti code.

It is inspired in the `Either a b` type of Haskell (but with `b` always an
error in the form of a scalar Perl string) or the ROP programming anyone
discovers when using F#.

# USAGE

You can find more usage examples in the tests `t/Then.t`. For examples of
how to use inside Moose `t/Example.t`

# Running tests

A `Dockerfile` is provided in order to run the tests without needing
any perl in your system. Just run:

    $ make -f Makefile.docker test

This should construct an image with the necessary dependencies, copy
the source into the image and run the tests.

# AUTHOR

    Pau Cervera i Badia
    CAPSiDE
    pau.cervera@capside.com

# BUGS and SOURCE

The source code is located here: [https://github.com/paudirac/Perl-Either](https://github.com/paudirac/Perl-Either)

Please report bugs to: [https://github.com/paudirac/Perl-Either/issues](https://github.com/paudirac/Perl-Either/issues)

# COPYRIGHT and LICENSE

Copyright (c) 2017 by CAPSiDE

This code is distributed under the Apache 2 License. The full text of the license can be found in the LICENSE file included with this module.
