use Test::Spec;
use Either qw(either);
#use PerlX::MethodCallWithBlock;

describe "then" => sub {

    it "can be execute after success" => sub {
        my $res = either { 40 / 2 };
        my $res2 = $res->then("Can't divide" => sub { $_ / 2 });
        ok($res2->is_valid && $res2->value == 10);
    };

    it "shortcuts a failing either" => sub {
        my $res = either { 40 / 0 };
        my $res2 = $res->then("Can't divide" => sub { $_ / 2 });
        ok(!$res2->is_valid);
    };

    it "can be chained" => sub {
        my $res = either { 40 / 2 };
        my $res2 = $res->then(
            "Can't divide" => sub { $_ / 2 },
            "spy" => sub { print STDERR "\nspy:" . $_ . "\n"; return $_ },
            "Can't multiply" => sub { $_ * 4 },
            "spy2" => sub { print STDERR "\nspy2:" . $_ . "\n"; return $_ },
            "Can't sum" => sub { $_ + 2 });
        #ok($res2->is_valid && $res2->value == 42);
        is($res2->value, 42);
    };

    it "can be chained even when fails" => sub {
        my $res = either { 40 / 2 };
        my $res2 = $res->then(
            "Can't divide" => sub { $_ / 0 },
            "Can't multiply" => sub { $_ * 4 },
            "Can't sum" => sub { $_ + 2 });
        ok(!$res2->is_valid && $res2->error eq "Can't divide");
    };

};

runtests unless caller;
1;
