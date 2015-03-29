#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More tests => 2;
use Test::Output;

use Franckys::Trace;

#  
# POWER-SET(a b c) -> ( [] [a] [b] [c] [a b] [a c] [b c] [a b c] )
#
sub power_set {
   # Let's try the pretty-print trace mode...
   &pp_tracein;

   my @pset;

   if ( @_ == 0 ) {
      @pset = ( [] );
   }
   else {
      my ($car, @cdr) = @_;
      @pset 
          = map {
              ( $_, [ $car, @$_ ] )
            } power_set( @cdr ) ;
  }

  pp_traceout( @pset );

  return @pset;
}


# TEST 1
trace_on();

my $expected = do {
    local $/ = undef;
    <DATA>
};

stderr_is { power_set(qw(a b c d e)) } $expected, 'Traced power_set(5)';

# TEST 2
trace_off();
stderr_is { power_set(qw(a b c d e)) } '', 'Untraced power_set(5)';

__DATA__
--> main::power_set()
.   Arg1 = 'a';
.   Arg2 = 'b';
.   Arg3 = 'c';
.   Arg4 = 'd';
.   Arg5 = 'e';
.   --> main::power_set()
.   .   Arg1 = 'b';
.   .   Arg2 = 'c';
.   .   Arg3 = 'd';
.   .   Arg4 = 'e';
.   .   --> main::power_set()
.   .   .   Arg1 = 'c';
.   .   .   Arg2 = 'd';
.   .   .   Arg3 = 'e';
.   .   .   --> main::power_set()
.   .   .   .   Arg1 = 'd';
.   .   .   .   Arg2 = 'e';
.   .   .   .   --> main::power_set()
.   .   .   .   .   Arg1 = 'e';
.   .   .   .   .   <-- Res1 = []
.   .   .   .   <-- Res1 = []
.   .   .   .       Res2 = ['e']
.   .   .   <-- Res1 = []
.   .   .       Res2 = ['d']
.   .   .       Res3 = ['e']
.   .   .       Res4 = ['d','e']
.   .   <-- Res1 = []
.   .       Res2 = ['c']
.   .       Res3 = ['d']
.   .       Res4 = ['c','d']
.   .       Res5 = ['e']
.   .       Res6 = ['c','e']
.   .       Res7 = ['d','e']
.   .       Res8 = ['c','d','e']
.   <-- Res1 = []
.       Res2 = ['b']
.       Res3 = ['c']
.       Res4 = ['b','c']
.       Res5 = ['d']
.       Res6 = ['b','d']
.       Res7 = ['c','d']
.       Res8 = ['b','c','d']
.       Res9 = ['e']
.       Res10 = ['b','e']
.       Res11 = ['c','e']
.       Res12 = ['b','c','e']
.       Res13 = ['d','e']
.       Res14 = ['b','d','e']
.       Res15 = ['c','d','e']
.       Res16 = ['b','c','d','e']
<-- Res1 = []
    Res2 = ['a']
    Res3 = ['b']
    Res4 = ['a','b']
    Res5 = ['c']
    Res6 = ['a','c']
    Res7 = ['b','c']
    Res8 = ['a','b','c']
    Res9 = ['d']
    Res10 = ['a','d']
    Res11 = ['b','d']
    Res12 = ['a','b','d']
    Res13 = ['c','d']
    Res14 = ['a','c','d']
    Res15 = ['b','c','d']
    Res16 = ['a','b','c','d']
    Res17 = ['e']
    Res18 = ['a','e']
    Res19 = ['b','e']
    Res20 = ['a','b','e']
    Res21 = ['c','e']
    Res22 = ['a','c','e']
    Res23 = ['b','c','e']
    Res24 = ['a','b','c','e']
    Res25 = ['d','e']
    Res26 = ['a','d','e']
    Res27 = ['b','d','e']
    Res28 = ['a','b','d','e']
    Res29 = ['c','d','e']
    Res30 = ['a','c','d','e']
    Res31 = ['b','c','d','e']
    Res32 = ['a','b','c','d','e']
