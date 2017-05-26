use Test::Spec;

package MooseSut {
  use Either qw(either);
  use Moose;

  has service => (is => 'ro');

  sub foo {
    my $self = shift;
    my $res = either { $self->service->baz(40); };
    return $res
      ->then("service failed at bar" => sub { $self->_bar($_) })
      ->then('failed at frobnicate' => sub { $self->_frobnicate($_) });
  }

  sub _bar {
    my ($self, $arg) = @_;
    return $arg + 2;
  }

  sub _frobnicate {
    my ($self, $arg) = @_;
    return $arg + 39;
  }

};

package Stub {
  use Moose;

  has val => (is => 'ro');

  sub baz {
    my ($self, $arg) = @_;
    my $divisor = $self->val;
    return $arg / $divisor;
  }
};


describe "Stub" => sub {

  it "works as expected" => sub {
    my $stub = Stub->new(val => 40);
    is($stub->baz(40), 1);
  };

  it "fails as expected" => sub {
    my $stub = Stub->new(val => 0);
    my $res = eval {
      $stub->baz(40);
    };
    ok($@);
  };

};

describe "MooseSut" => sub {

  it "behaves ok when service doesn't fail" => sub {
    my $stub = Stub->new(val => 40);
    my $sut = MooseSut->new(service => $stub);
    my $res = $sut->foo;
    ok($res->is_valid && $res->value == 42);
  };

  it "behaves ok when service fails" => sub {
    my $stub = Stub->new(val => 0);
    my $sut = MooseSut->new(service => $stub);
    my $res = $sut->foo;
    ok(!$res->is_valid);
  };

};

runtests unless caller;
1;
