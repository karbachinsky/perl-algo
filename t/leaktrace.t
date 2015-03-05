use strict;
use Test::Requires{ 'Test::LeakTrace' => 0.13 };
use Test::More;

use Algorithm::Statistic qw/:all/;

no_leaks_ok {
    my ($statistic) = kth_order_statistic(sub{$_[0] <=> $_[1]}, [0,1], 1); 

    my ($mediana) = mediana(sub{$_[0] <=> $_[1]}, [0,1]);
};

done_testing();
