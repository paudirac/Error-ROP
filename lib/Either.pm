package Either;
use Imp::Either;

sub success {
    return Imp::Either->new(value => shift);
}

sub error {
    return Imp::Either->new(error => shift);
}

1;
