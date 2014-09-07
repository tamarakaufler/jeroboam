#!/usr/bin/perl;

use v5.10;
use strict;
use warnings;

use Data::Dumper qw(Dumper);

use Test::More tests => 18;    
#use Test::More qw(no_plan);    

use Test::MockObject;

use FindBin qw($Bin);
use lib $Bin;

BEGIN { use_ok( 'Spreadsheet' );
        can_ok( 'Spreadsheet', '_create_cells');
        can_ok( 'Spreadsheet', 'cell' );
        can_ok( 'Spreadsheet', 'print' );
}

my $ss;
$ss = Spreadsheet->new;

is(ref $ss, 'Spreadsheet',     'Instance correctly blessed to Spreadsheet');

my @rows    = ( 1  .. 10 );
my @columns = ('A' .. 'H');
is_deeply($ss->columns, \@columns,  'Correct spreadsheet columns');
is_deeply($ss->rows,    \@rows,     'Correct spreadsheet rows');

my @columns2 = ('D' .. 'I');
eval {
    $ss->columns(\@columns2);
};
like($@, qr/Cannot assign a value to a read-only/, 'Correctly failed on trying to assign a read only attribute');
is_deeply($ss->columns, \@columns,  'Correctly still keeping original spreadsheet columns');

## do the same for rows

my $cell = $ss->cell('F8');
is(ref $cell, 'Cell',   'Cell instance correctly blessed into the Cell class');
ok($cell->value == 0,   'Cell\'s value is the default numeric zero');
ok($cell->value eq '',  'Cell\'s value is the default empty string');

$ss->cell('F8')->value(3.33);
ok($cell->value == 3.33, 'Cell\'s value is the default numeric zero');

$ss->cell('F8')->clear;
ok($cell->value == 0,   'Cell\'s value is numeric zero after clearing');
ok($cell->value eq '',  'Cell\'s value is an empty string after clearing');

eval {
    $ss->cell('3D');
};
like ($@, qr/format error/, 'Incorrect input (3D) for cell method');

eval {
    $ss->cell('D33');
};
like ($@, qr/format error/, 'Incorrect input (D33) for cell object');

eval {
    $ss->cell('Z3');
};
like ($@, qr/format error/, 'Incorrect input (Z3) for cell object');

done_testing();

