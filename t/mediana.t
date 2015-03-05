#!perl

use strict;
use warnings;

use Test::More;

use_ok( 'Algorithm::Statistic', ':all' );

sub compare {
    $_[0] <=> $_[1];
}

{
    is(mediana(\&compare, [4,5,3,6,7,8,9,2,1,0]), 5);
    
    is(mediana(\&compare, [16,18,10,16,12]), 16);

    is(mediana(\&compare, [1]), 1);
    is(mediana(\&compare, [0, 1]), 1);
    
    is(mediana(\&compare, [4.1,5.2,3.3,6.4,7.5,8.6,9.7,2.8,1.9,0.0]), 5.2);
    
    is(mediana(\&compare, [1,2,3,4]), 3);

    {
        no warnings 'all';
        is(mediana(\&compare, []), undef);
        is(mediana(\&compare, {}), undef);
    }
}

done_testing();
