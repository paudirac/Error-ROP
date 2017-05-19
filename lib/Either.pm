package Either;
use Imp::Either;

sub success {
    return Imp::Either->new(value => shift);
}

sub error {
    return Imp::Either->new(error => shift);
}

sub either (&) {
    my $code = \&{shift @_};

    my $res = eval {
        $code->(@_);
    };
    return error($@) if $@;
    return success($res);
}

1;
