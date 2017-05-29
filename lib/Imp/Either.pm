package Imp::Either;
use Moose;

has value => (is => 'ro', required => 0, default => undef);
has error => (is => 'ro', required => 0, default => '');

sub is_valid {
    return shift->error eq '';
}

sub then {
    my ($self, @then_clauses) = @_;
    my $either = $self;

    my $length = @then_clauses / 2;
    for(my $i = 0; $i < $length; $i++) {
        my $err = $then_clauses[2 * $i];
        my $fn = $then_clauses[2 * $i + 1];
        if ($either->is_valid) {
            local $_ = $either->value;
            my $code = sub { $fn->($_); };
            my $res = eval {
                $code->();
            };
            if ($@) {
                my $msg = length $err > 0 && $err ne 'undef' ? $err : $@;
                return Imp::Either->new(error => $msg);
            }
            $either = Imp::Either->new(value => $res);
        }
    }

    return $either;
}


__PACKAGE__->meta->make_immutable;
1;
