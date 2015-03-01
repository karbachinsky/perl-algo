use strict;
use Test::Requires { 'Test::LeakTrace' => 0.13 };
use Test::More;

use KOrderStatistic qw/:all/;


no_leaks_ok {
    my ($statistic) = kth_order_statistic([0,1], 1); 
};

done_testing;
