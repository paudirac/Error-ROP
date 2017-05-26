package Imp::Either;
use Moose;

has value => (is => 'ro', required => 0, default => undef);
has error => (is => 'ro', required => 0, default => '');

sub is_valid {
    return shift->error eq '';
}

sub _either (&) {
    my $code = \&{shift @_};

    my $res = eval {
        $code->(@_);
    };
    return Imp::Either->new(error => $@) if $@;
    return Imp::Either->new(success => $res);
}

sub _bind {
    my $either = shift @_;
    my $fn = \&{shift @_};
    return $either->is_valid ? _either {
        local $_ = $either->value;
        return sub { $fn->($either->value); }
    } : $either;
}

sub thenf {
    my $self = shift @_;
    my $fn = \&{shift @_};
    #local $_ = $self->value;
    return _bind($self, $fn);
    #return $fn->($_);
}

sub then {
    #my ($self, %then_clauses) = @_;
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
                return Imp::Either->new(error => $err);
            }
            $either = Imp::Either->new(value => $res);
        }
    }

    return $either;
}


__PACKAGE__->meta->make_immutable;
1;
