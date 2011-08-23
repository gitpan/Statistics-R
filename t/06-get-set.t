#! perl

use strict;
use warnings;
use Test::More;
use Statistics::R;

plan tests => 76;


my ($R, $input, $output);


ok $R = Statistics::R->new();


$input = undef;
ok $R->set('x', $input), 'undef';
is $R->get('x'), undef;


$input = 123;
ok $R->set('x', $input);
ok $output = $R->get('x'), 'integer';
is ref($output), '';
is $output, 123;


# R default number of digits is 7
$input = 0.93945768644;
ok $R->set('x', $input), 'real number';
ok $output = $R->get('x');
is ref($output), '';
is $output, sprintf("%.7f", $input);


$input = "apocalypse";
ok $R->set('x', $input), 'string';
ok $output = $R->get('x');
is ref($output), '';
is $output, "apocalypse";


$input = "a string";
ok $R->set('x', $input), 'string with witespace';
ok $output = $R->get('x');
is ref($output), '';
is $output, "a string";


# Mixed arrays are considered as string arrays by R, thus there is no digit limit
$input = [123, "a string", 'two strings', 0.93945768644];
ok $R->set('x', $input), 'mixed array';
ok $output = $R->get('x');
is ref($output), 'ARRAY';
is $$output[0], 123;
is $$output[1], "a string";
is $$output[2], "two strings";
is $$output[3], 0.93945768644;


$input = [123,142,147,153,145,151,165,129,133,150,142,154,131,146,151,136,147,156,141,155,147,165,168,146,148,146,142,145,161,157,154,137,130,161,130,156,140,145,154];
ok $R->set('x', $input), 'large array of integers';
ok $output = $R->get('x');
is ref($output), 'ARRAY';
for (my $i = 0; $i < scalar @$input; $i++) {
    is $$output[$i], $$input[$i];
}


$input = [1, 2, 3];
ok $R->set('x', $input), 'data frame';
is $R->run(q`a <- data.frame(first=x)`), '';
ok $output = $R->get('a$first');
is ref($output), 'ARRAY';
is $$output[0], 1;
is $$output[1], 2;
is $$output[2], 3;


ok $R->stop();
