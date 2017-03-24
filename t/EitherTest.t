use Test::Spec;
use Either;

sub always_succeeds {
    return Either::success(shift);
}

sub always_fails {
    return Either::error("You don't have permissions.");
}

sub divide_or_not {
    my $number = shift;
    my $res;
    eval {
        $res = 42 / $number;
    };
    if ($@) {
        return Either::error($@);
    }
    return Either::success($res);
}

describe "Either class" => sub {
    it "wraps valid stuff" => sub {
        my $res = always_succeeds(42);
        ok($res->is_valid);
    };
    it "can get valid stuff" => sub {
        my $res = always_succeeds(42);
        is(42, $res->value);
    };
    it "can have an error" => sub {
        my $res = always_fails(42);
        ok(!$res->is_valid);
    };
};

describe "An operation" => sub {
    it "can succeed" => sub {
        my $res = divide_or_not(3);
        ok($res->is_valid);
    };
    it "can fail" => sub {
        my $res = divide_or_not(0);
        ok(!$res->is_valid);
    };
};

runtests unless caller;
1;
