#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 10;

use_ok( 'Franckys::Trace' );
can_ok( 'Franckys::Trace', 'trace_on');
can_ok( 'Franckys::Trace', 'trace_off');
can_ok( 'Franckys::Trace', 'trace_mode');
can_ok( 'Franckys::Trace', 'tracein');
can_ok( 'Franckys::Trace', 'traceout');
can_ok( 'Franckys::Trace', 'pp_tracein');
can_ok( 'Franckys::Trace', 'pp_traceout');
can_ok( 'Franckys::Trace', 'rp_tracein');
can_ok( 'Franckys::Trace', 'rp_traceout');

diag( "Testing Franckys::Trace $Franckys::Trace::VERSION, Perl $], $^X" );
