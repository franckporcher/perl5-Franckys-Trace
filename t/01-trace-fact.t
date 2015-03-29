#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More tests => 2;
use Test::Output;

use Franckys::Trace;

sub fact {
   &tracein;
   my $n = shift;

   my $fact_n = $n > 1  ?  $n * fact($n - 1) : 1 ;

   traceout($fact_n);

   return $fact_n;
}

# TEST 1
trace_on();

my $expected = do {
    local $/ = undef;
    <DATA>
};

stderr_is { fact(5) } $expected, 'Traced fact(5)';


# TEST 2
trace_off();
stderr_is { fact(5) } '', 'Untraced fact(5)';

__DATA__
--> main::fact(5)
.   --> main::fact(4)
.   .   --> main::fact(3)
.   .   .   --> main::fact(2)
.   .   .   .   --> main::fact(1)
.   .   .   .   <-- 1
.   .   .   <-- 2
.   .   <-- 6
.   <-- 24
<-- 120
