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

sub other_calc {
    my $number = shift;
    my $first_step = divide_or_not($number - 1);
    if ($first_step->is_valid) {
        return Either::success($first_step->value + 2);
    }
    return $first_step;
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
    it "can succeed with multiple applications" => sub {
        my $res = other_calc(43);
        ok($res->is_valid);
    };
    it "can fail with multiple applications" => sub {
        my $res = other_calc(1);
        ok(!$res->is_valid);
    };
};

describe "a block" => sub {
    it "can succeed" => sub {
        my $res = Either::either { 42 / 2 };
        ok($res->is_valid);
    };
    it "can succeed and have a value" => sub {
        my $res = Either::either { 42 / 2 };
        ok($res->is_valid && $res->value == 21);
    };
    it "can fail" => sub {
        my $res = Either::either { 42 / 0 };
        ok(!$res->is_valid);
    };
};

describe "eithers" => sub {
    it "can be concatenated" => sub {
        my $res = Either::either { 40 / 2 };
        my $res2 = $res->then { print "hello"; };
        #ok($res2->is_valid && $res2->value == 10);
        fail;
    };
    it "shorcut when failed" => sub {
        fail;
    };
};

runtests unless caller;
1;
