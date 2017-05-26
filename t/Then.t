use Test::Spec;
use Either qw(either);

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
            "Can't multiply" => sub { $_ * 4 },
            "Can't sum" => sub { $_ + 2 });
        ok($res2->is_valid && $res2->value == 42);
    };

    it "can be chained individually" => sub {
        my $res = either { 40 / 2 };
        my $res2 = $res
            ->then("Can't divide" => sub { $_ / 2 })
            ->then("Can't multiply" => sub { $_ * 4 })
            ->then("Can't sum" => sub { $_ + 2 });
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

    # either { 40 / 2 } then { $_ / 0 } then { printar($_); $_ }

};

runtests unless caller;
1;
