package Algo;

use strict;
use warnings;
use XSLoader;

use Exporter 5.57 'import';

our $VERSION     = '0.01';
our %EXPORT_TAGS = ( 'all' => [qw<kth_order_statistic>] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );

XSLoader::load('Algo', $VERSION);

1;

=head1 NAME

Algo - algorithms library

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Algo;

=head1 DESCRIPTION

This module provides several math and statistical algorithms implementations in C++ XS for perl.

=head2 Functions

=head3 C<< kth_order_statistic(compare_sub, array_ref, k) >>

This functions allows to find k-th order statistic for certain array of elements.
Note that this function changes imput array (like std::nth_element im STL C++) according to the next rule:
element at k-th position will become k-tg order atatistic. Each element from the left of k will be less then k-th
and each from the right will be greater. This algorithm work with linear complexity O(n).

=head1 BUGS

If you find a bug please contact me via email.

=head1 AUTHOR

Igor KarbachinskyE <igorkarbachinsky@mail.ru>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2015, Igor Karbachinsky. All rights reserved.

=cut
