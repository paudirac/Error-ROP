package Imp::Either;
use Moose;

has value => (is => 'ro', required => 0, default => undef);
has error => (is => 'ro', required => 0, default => '');

sub is_valid {
    return shift->error eq '';
}

sub then (&) {
    my $self = shift;
    print STDERR "\n\n" . "then" . "\n\n";
    my $code = \&{shift @_};

    return $self if (!$self->is_valid);
    my $value = $self->value;
    my $res = eval {
        $code->(@_);
    };
    return error($@) if $@;
    return $self->new($res);
}

__PACKAGE__->meta->make_immutable;
1;
