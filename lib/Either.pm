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

=cut
