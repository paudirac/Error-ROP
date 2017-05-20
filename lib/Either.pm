package Either;
use Imp::Either;
use Exporter qw/import/;

our @EXPORT_OK = qw/success error either bind/;

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

# Either a -> (a -> Either b) -> Either b
sub bind {
    my $either = shift @_;
    my $fn = \&{shift @_};
    return $either->is_valid ? either { $fn->($either->value) } : $either;
}

1;
