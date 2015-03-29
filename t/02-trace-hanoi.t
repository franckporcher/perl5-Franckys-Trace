#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More  tests => 2;
use Test::Output;

use Franckys::Trace;

sub hanoi {
   &tracein;

   my ($n, $from, $to, $aux) = @_;

   if ($n) {
      hanoi( $n - 1, $from, $aux, $to);
      trace( "Moving plate from $from to $to" );
      hanoi( $n - 1, $aux, $to, $from);
   }

   traceout();
}

# TEST 1
trace_on();

my $expected = do {
    local $/ = undef;
    <DATA>
};

stderr_is { hanoi(5, qw(A B C)) } $expected, 'Traced hanoi(5)';

# TEST 2
trace_off();
stderr_is { hanoi(5, qw(A B C)) } '', 'Untraced hanoi(5)';

__DATA__
--> main::hanoi(5, 'A', 'B', 'C')
.   --> main::hanoi(4, 'A', 'C', 'B')
.   .   --> main::hanoi(3, 'A', 'B', 'C')
.   .   .   --> main::hanoi(2, 'A', 'C', 'B')
.   .   .   .   --> main::hanoi(1, 'A', 'B', 'C')
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from A to B
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from A to C
.   .   .   .   --> main::hanoi(1, 'B', 'C', 'A')
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from B to C
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   .   Moving plate from A to B
.   .   .   --> main::hanoi(2, 'C', 'B', 'A')
.   .   .   .   --> main::hanoi(1, 'C', 'A', 'B')
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from C to A
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from C to B
.   .   .   .   --> main::hanoi(1, 'A', 'B', 'C')
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from A to B
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   <-- ()
.   .   Moving plate from A to C
.   .   --> main::hanoi(3, 'B', 'C', 'A')
.   .   .   --> main::hanoi(2, 'B', 'A', 'C')
.   .   .   .   --> main::hanoi(1, 'B', 'C', 'A')
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from B to C
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from B to A
.   .   .   .   --> main::hanoi(1, 'C', 'A', 'B')
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from C to A
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   .   Moving plate from B to C
.   .   .   --> main::hanoi(2, 'A', 'C', 'B')
.   .   .   .   --> main::hanoi(1, 'A', 'B', 'C')
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from A to B
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from A to C
.   .   .   .   --> main::hanoi(1, 'B', 'C', 'A')
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from B to C
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   <-- ()
.   <-- ()
.   Moving plate from A to B
.   --> main::hanoi(4, 'C', 'B', 'A')
.   .   --> main::hanoi(3, 'C', 'A', 'B')
.   .   .   --> main::hanoi(2, 'C', 'B', 'A')
.   .   .   .   --> main::hanoi(1, 'C', 'A', 'B')
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from C to A
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from C to B
.   .   .   .   --> main::hanoi(1, 'A', 'B', 'C')
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from A to B
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   .   Moving plate from C to A
.   .   .   --> main::hanoi(2, 'B', 'A', 'C')
.   .   .   .   --> main::hanoi(1, 'B', 'C', 'A')
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from B to C
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from B to A
.   .   .   .   --> main::hanoi(1, 'C', 'A', 'B')
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from C to A
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   <-- ()
.   .   Moving plate from C to B
.   .   --> main::hanoi(3, 'A', 'B', 'C')
.   .   .   --> main::hanoi(2, 'A', 'C', 'B')
.   .   .   .   --> main::hanoi(1, 'A', 'B', 'C')
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from A to B
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from A to C
.   .   .   .   --> main::hanoi(1, 'B', 'C', 'A')
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from B to C
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   .   Moving plate from A to B
.   .   .   --> main::hanoi(2, 'C', 'B', 'A')
.   .   .   .   --> main::hanoi(1, 'C', 'A', 'B')
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from C to A
.   .   .   .   .   --> main::hanoi(0, 'B', 'A', 'C')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   .   Moving plate from C to B
.   .   .   .   --> main::hanoi(1, 'A', 'B', 'C')
.   .   .   .   .   --> main::hanoi(0, 'A', 'C', 'B')
.   .   .   .   .   <-- ()
.   .   .   .   .   Moving plate from A to B
.   .   .   .   .   --> main::hanoi(0, 'C', 'B', 'A')
.   .   .   .   .   <-- ()
.   .   .   .   <-- ()
.   .   .   <-- ()
.   .   <-- ()
.   <-- ()
<-- ()
