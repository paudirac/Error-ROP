package Imp::Either;
use Moose;

has value => (is => 'ro', required => 0, default => undef);
has failure => (is => 'ro', required => 0, default => '');

sub is_valid {
    return shift->failure eq '';
}

sub _then_hash {
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
                return Imp::Either->new(failure => $msg);
            }
            $either = Imp::Either->new(value => $res);
        }
    }

    return $either;
}

sub _then_list {
    my ($self, @then_clauses) = @_;
    my $either = $self;

    my $length = @then_clauses;
    for(my $i = 0; $i < $length; $i++) {
        my $fn = $then_clauses[$i];
        if ($either->is_valid) {
            local $_ = $either->value;
            my $code = sub { $fn->($_); };
            my $res = eval {
                $code->();
            };
            if ($@) {
                return Imp::Either->new(failure => $@);
            }
            $either = Imp::Either->new(value => $res);
        }
    }

    return $either;
}

sub then {
    my ($self, @then_clauses) = @_;

    if((scalar @then_clauses) % 2 == 0) {
	$self->_then_hash(@then_clauses);
    }
    else {
        $self->_then_list(@then_clauses);
    }
}


__PACKAGE__->meta->make_immutable;
1;
