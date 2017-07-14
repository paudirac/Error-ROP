# Perl-Either

This is a simple and lightweight implementation of the Either type in Perl.

Given the Perl mechanism for dealing with exceptions, `eval`, this
module tries to provide a way to organize the code without resorting
to n + 1 levels of evaling and spaghetti code.

It is inspired in the `Either a b` type of Haskell (but with `b` always an
error in the form of a scalar Perl string) or the ROP programming anyone
discovers when using F#.

## Usage

Use the `either` function as a substitute of `eval` and then
chain your calls with `then`, like in:

```perl
my $res = either { 40 / 0 };
my $res2 = $res
  ->then("Can't divide" => sub { $_ / 2 })
  ->then("Can't multiply" => sub { $_ * 4 })
  ->then("Can't sum" => sub { $_ + 2 });
```

To see more detailed info, look [the tests](t/Then.t) for the `then`.
You can also use it [inside a Moose class](t/Example.t).

## Running the tests

A `Dockerfile` is provided in order to run the tests without needing
any perl in your system. Just run:

```shell
$ make -f Makefile.docker test
```

This should construct an image with the necessary dependencies, copy
the source into the image and run the tests.
