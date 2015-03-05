package Algorithm::Statistic;

use strict;
use warnings;
use XSLoader;

use Exporter 5.57 'import';

our $VERSION     = '0.01';
our %EXPORT_TAGS = ( 'all' => [qw<kth_order_statistic mediana>] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );

XSLoader::load('Algorithm::Statistic', $VERSION);

1;

=head1 NAME

Algorithm::Statistic - different statistical algorithms library

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Algorithm::Statistic qw/:all/;

=head1 DESCRIPTION

This module provides several math and statistical algorithms implementations in C++ XS for perl.

=head1 Functions

=head2 C<< kth_order_statistic(compare_sub, array_ref, k) >>

This function allows to find k-th order statistic for certain array of elements. 
Note that this function changes input array (like std::nth_element im STL C++) according to the next rule:
element at k-th position will become k-th order atatistic. Each element from the left of k will be less then k-th
and each from the right will be greater. This algorithm works with linear complexity O(n).

    $statistic = kth_order_statistic(\&compare, $array_ref, $k);

For example C<compare> function could be simple comparison for integers:

    sub compare {
        $_[0] <=> $_[1]
    }

=head2 C<< mediana(compare_sub, array_ref) >>

This function allows to find mediana for certain array of elements. This method is the same as n/2 kth order statistc.
Like C<kth_order_statistic> this functions changes input array according to the same rule.

    $mediana = mediana(\&compare, $array_ref);

=head1 BUGS

If you find a bug please contact me via email.

=head1 AUTHOR

Igor KarbachinskyE <igorkarbachinsky@mail.ru>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2015, Igor Karbachinsky. All rights reserved.

=cut
