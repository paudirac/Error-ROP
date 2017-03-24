package Imp::Either;
use Moose;

has value => (is => 'ro', required => 0, default => undef);
has error => (is => 'ro', required => 0, default => '');

sub is_valid {
    return shift->error eq '';
}

__PACKAGE__->meta->make_immutable;
1;
