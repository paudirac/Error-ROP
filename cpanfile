requires 'Moose';
requires 'PerlX::MethodCallWithBlock';

on 'develop' => sub {
  requires 'Test::Spec';
  requires 'App::Prove::Watch';
};
