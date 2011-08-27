#! /usr/bin/env perl

use strict;
use warnings;
use Statistics::R;
  
# Create a communication bridge with R and start R
my $R = Statistics::R->new( log_dir => './tmp' );

print "log_dir = ".$R->{ BRIDGE }->{ LOG_DIR }."\n";


# Pass and retrieve data
my $input_value = 1;
$R->set('x', $input_value);
$R->run(q`y <- x^2`);
my $output_value = $R->get('y');
print "y = $output_value\n";


# Run simple R commands
$R->run(q`postscript("file.ps" , horizontal=FALSE , width=500 , height=500 , pointsize=1)`);
$R->run(q`plot(c(1, 5, 10), type = "l")`);

sleep();

$R->run(q`dev.off()`);

$R->clean_up();

$R->stop();

exit;
