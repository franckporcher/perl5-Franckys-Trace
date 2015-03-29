#===============================================================================
#
#         FILE: Franckys::Trace
#
#        USAGE: use Francky::Trace;
#
#  DESCRIPTION: Provide a simple trace mechanisme for debugging complex call
#               trees
#
#      OPTIONS: 
# REQUIREMENTS: Data::Dumper
#               Perl6::Export::Attrs;
#         BUGS: None so far
#        NOTES: Developped for project: MUTINY Tahiti
#
#       AUTHOR: Franck Porcher, Ph.D. - franck.porcher@franckys.com
# ORGANIZATION: Franckys
#      CREATED: Mer 18 fév 2015 21:06:50 PST
#     REVISION: v0.11
#
# Copyright (C) 1995-2015 - Franck Porcher, Ph.D 
# www.franckys.com
# Tous droits réservés - All rights reserved
#===============================================================================
package Franckys::Trace;
use v5.16;                                   ## no critic (ValuesAndExpressions::ProhibitVersionStrings)
use strict;
use warnings;
use autodie;
use feature  qw( switch say unicode_strings );

#----------------------------------------------------------------------------
# UTF8 STUFF
#----------------------------------------------------------------------------
use utf8;
use warnings            FATAL => "utf8";
use charnames           qw( :full :short );
use Encode              qw( encode decode );
use Unicode::Collate;
use Unicode::Normalize  qw( NFD NFC );

#----------------------------------------------------------------------------
# REQUIREMENTS
#----------------------------------------------------------------------------
use Data::Dumper;
$Data::Dumper::Indent    = 0;
$Data::Dumper::Quotekeys = 0;
$Data::Dumper::Sortkeys  = 1;
$Data::Dumper::Pad       = '';

#----------------------------------------------------------------------------
# I/O
#----------------------------------------------------------------------------
use open qw( :encoding(UTF-8) :std );

#----------------------------------------------------------------------------
# EXPORTED STUFF
#----------------------------------------------------------------------------
use Perl6::Export::Attrs;

#----------------------------------------------------------------------------
# GLOBAL OBJECTS AND CONSTANTS
#----------------------------------------------------------------------------
# CONSTANTS
# GLOBALS

#----------------------------------------------------------------------------
# POD
#----------------------------------------------------------------------------
=pod

=head1 NAME

Trace - A simple trace mechanism 

=head1 VERSION

Version 0.11

=cut

use version; our $VERSION = 'v0.11';           # Keep on same line

=pod

=head1 SYNOPSIS

  #!/usr/bin/env perl
  use strict;
  use warnings;

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


  sub fact {
     &tracein;
     my $n = shift;

     my $fact_n = $n > 1  ?  $n * fact($n - 1) : 1 ;

     traceout($fact_n);

     $fact_n;
  }


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
                ( $_, [ $first, @$_ ] )
              } power_set( @cdr ) ;
    }

    pp_traceout( @pset )
  }



  # Enable the regular trace mode (pretty-print not enabled by default)
  #   I can enable pretty-print mode by calling trace_on(1);
  trace_on();

  my $n = $ARGV[0] || 5;

  # Try out factorial,the 2nd Hello World! program...
  fact($n);

  # Try out the mythical hanoi...
  hanoi( $n, qw(A B C));

  # Try out the nice power_set...
  power_set( ('' 'a' .. 'z')[1..$n] ); 

  # Disable the trace mode
  trace_off();

=head1 EXPORT

=over 4

=item &trace_on()

=item &trace_off()

=item &trace_mode()

=item &tracein( @args );

=item &pp_tracein( @args );

=item &rp_tracein( @args );

=item &traceout( @return_values );

=item &pp_traceout( @return_values );

=item &rp_traceout( @return_values );

=back

=head1 DESCRIPTION

Franckys::Trace is a simple module aimed at providing the developer with a basic mechanism
for tracing in and out complex call trees for debugging purposes.

Please refer to the example above for a typical use of the module's main functions, namely 
B<&tracein()> and B<&traceout()>.

=head1 FUNCTIONS

=cut

#----------------------------------------------------------------------------
# LIBRARY
#----------------------------------------------------------------------------

{ 
    # Hidden state
    my $mode           = 0;
    my $margin_level   = 0;
    my $margin_pattern = '.   ';
    my $pretty_trace;

#
#====[ trace_on()* ]====
#
=pod

=head2 trace_on( $pretty-print-flag );

Turn the trace mode on (Exported by default).

=cut

    sub trace_on :Export(:DEFAULT) {
        $pretty_trace  = $_[0] || 0;
        return $mode = 1;
    }



#
#====[ trace_off()* ]====
#
=pod

=head2 trace_off();

Turn the trace mode off (Exported by default).

=cut

    sub trace_off :Export(:DEFAULT) { return $mode = 0 }



#
#====[ trace_mode()* ]====
#
=pod

=head2 my $bool = trace_mode();

Lookup the current trace mode (Exported by default);

=cut

    sub trace_mode :Export(:DEFAULT) { return $mode }



#
#====[ pretty_trace_mode()* ]====
#
=pod

=head2 my $bool = pretty_trace_mode();

Lookup the current pretty-trace mode (Not exported by default);

=cut

    sub pretty_trace_mode { return $pretty_trace }



#
#====[ trace_reset() ]====
#
=pod

=head2 my $bool = reset_trace_level( $margin_level );

Reset the trace level to I<$margin_level> or 0 (Not exported by default).

=cut

    sub reset_trace_level {
        return $margin_level = $_[0] || 0;
    }



#
#====[ trace_margin() ]====
#
=pod

=head2 my $str = trace_margin();

Returns the margin associated with the current trace level (Not exported by default).

=cut

    sub trace_margin {  return $margin_pattern x $margin_level }



#
#====[ incr_trace_margin() ]====
#
=pod

=head2 my $n = incr_trace_margin();

Returns the trace's margin before incrementing the margin level (Not exported by default).

=cut

    sub incr_trace_margin { 
        my $margin = trace_margin();
        $margin_level++;
        return $margin;
    }



#
#====[ decr_trace_margin() ]====
#
=pod

=head2 my $n = decr_trace_margin();

Returns the trace's margin after decrementing the margin level (Not exported by default).

=cut

    sub decr_trace_margin { 
        $margin_level--;
        return trace_margin();
    }

}



#
#====[ tracein(@args) ]====
#
=pod

=head2 (void) tracein($arg...);

Writes the subroutine call with its arguments, properly indented, to the
the standard error flow (Exported by default).

=cut

sub tracein :Export(:DEFAULT){
    return unless trace_mode();
    &tracein_aux;
}



#
#====[ pp_tracein(@args) ]====
#
=pod

=head2 (void) pp_tracein($arg...);

Same behaviour as B<&tracein()>, except for locally forcing the pretty-print mode independantly of
the current setting (Exported by default).

=cut

sub pp_tracein :Export(:DEFAULT){
    return unless trace_mode();
    my $save = pretty_trace_mode();
    trace_on( 1 );
    &tracein_aux;
    trace_on( $save );
}



#
#====[ rp_tracein(@args) ]====
#
=pod

=head2 (void) rp_tracein($arg...);

Same behaviour as B<&tracein()>, except for locally forcing the regular-print mode independantly of
the current setting (Exported by default).

=cut

sub rp_tracein :Export(:DEFAULT){
    return unless trace_mode();
    my $save = pretty_trace_mode();
    trace_on( 0 );
    &tracein_aux;
    trace_on( $save );
}



## tracein_aux() - common utilitary
sub tracein_aux {
    my $margin = incr_trace_margin();
    my $caller = (caller 2)[3];

    if (@_) {
        $Data::Dumper::Varname = 'Arg';

        if ( pretty_trace_mode() ) {
            say STDERR "${margin}--> ${caller}()";

            # Trace-margin AFTER incrementation
            # Exactly what we need to align args ;)
            $margin = trace_margin();
            my $i = 1;
            my @args = @_;
            @args = map {
                        $_ = Dumper($_);
                        s/^\$Arg1/sprintf('Arg%d', $i++)/e;
                        $_;
                    } @args;
            say STDERR "${margin}$_" foreach @args; 
        }
        else {
            my $args_str = join ', ', map { s/^\$Arg\d+[[:space:]]*=[[:space:]]*(.*);$/$1/; $_ } Dumper(@_);
            say STDERR "${margin}--> ${caller}($args_str)";
        }
    }
}



#
#====[ traceout(@args) ]====
#
=pod

=head2 (void) traceout($result...);

Writes the subroutine call's return,  along with its return values, properly indented, to the
the standard error flow (Exported by default).

=cut

sub traceout :Export(:DEFAULT){
    return unless trace_mode();
    &traceout_aux;
}



#
#====[ pp_traceout(@args) ]====
#
=pod

=head2 (void) pp_traceout($arg...);

Same behaviour as B<&traceout()>, except for locally forcing the pretty-print mode independantly of
the current setting (Exported by default).

=cut

sub pp_traceout :Export(:DEFAULT){
    return unless trace_mode();
    my $save = pretty_trace_mode();
    trace_on( 1 );
    &traceout_aux;
    trace_on( $save );
}



#
#====[ rp_traceout(@args) ]====
#
=pod

=head2 (void) rp_traceout($arg...);

Same behaviour as B<&traceout()>, except for locally forcing the regular-print mode independantly of
the current setting (Exported by default).

=cut

sub rp_traceout :Export(:DEFAULT){
    return unless trace_mode();
    my $save = pretty_trace_mode();
    trace_on( 0 );
    &traceout_aux;
    trace_on( $save );
}



## traceout_aux() - common utilitary
sub traceout_aux :Export(:DEFAULT){
    my $margin = decr_trace_margin();

    if (@_) {
        $Data::Dumper::Varname = 'Res';

        if ( pretty_trace_mode() ) {
            my $i = 1;
            my @res = @_;
            @res = map { 
                        $_ = Dumper($_); 
                        s/^\$Res1[[:space:]]*=[[:space:]]*(.*);$/sprintf('Res%d = %s', $i++, $1)/e; 
                        $_ 
                   } @res;

            say STDERR "${margin}<-- ", shift(@res);
            say STDERR "${margin}    $_" foreach @res;
        }
        else {
            my $res_str = join ', ', map { s/^\$Res\d+[[:space:]]*=[[:space:]]*(.*);$/$1/; $_ } Dumper(@_);

            if ( @_ > 1 ) {
                say STDERR "${margin}<-- ($res_str)";
            }
            else {
                say STDERR "${margin}<-- $res_str";
            }
        }
    }
    else {
        say STDERR "${margin}<-- ()";
    }
}

=pod

=head2 (void) trace($scalar...);

Writes any complementary information, properly indented, to the
the standard error flow (Exported by default).

=cut

sub trace :Export(:DEFAULT){
    return unless trace_mode();

    my $margin = trace_margin();

    $Data::Dumper::Varname = 'C';

    my @comments = map { s/^\$C\d+[[:space:]]*=[[:space:]]*['"]?(.*?)['"]?;$/$1/; $_ } Dumper(@_);

    say STDERR "${margin}$_" foreach @comments;

}

1;
__END__

=pod

=head1 DEPENDENCIES

=over 4

=item B<Data::Dumper>

=item B<Perl6::Export::Attrs>

=back


=head1 INCOMPATIBILITIES

This code is guaranteed to work with Perl 5.14 or higher.


=head1 ACKNOWLEDGEMENTS

I was first exposed to a full trace mechanism in the very early 80's while 
happily programming LISP systems :)

It was amazing to see how easily one could write a complete trace mechanism
that would not require that the user modify his code.

Instead, one would sing something like :

  (let ( 
          (x  (prog2 (trace fact) 
                     (fact 10)
                     (untrace fact)))
       )
       (do_something...)
  )

and one were all done !


=head1 AUTHOR

Franck PORCHER,PhD, C<< <franck.porcher at franckys.com> >>


=head1 BUGS

This module does not provide any mechanism for capturing and rethrowing errors arising
from the client's foreign calls, so to keep the indentation correct under any
situation.

The same goes if the client forgets to undo a call by calling the proper B<&traceout()> at
the last statement of the foreign function call.

Please report any bugs or feature requests to C<bug-franckys-trace at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Franckys-Trace>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Franckys::Trace


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Franckys-Trace>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Franckys-Trace>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Franckys-Trace>

=item * Search CPAN

L<http://search.cpan.org/dist/Franckys-Trace/>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2015 Franck PORCHER,PhD.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut
