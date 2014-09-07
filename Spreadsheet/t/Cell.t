#!/usr/bin/perl;

use strict;
use warnings;
use v5.10;

use Data::Dumper qw(Dumper);

use Test::More tests => 28;                    
#use Test::More qw(no_plan);                  

use Test::MockObject;

use FindBin qw($Bin);
use lib $Bin;

BEGIN { use_ok( 'Cell' );
        can_ok( 'Cell', '_update_calc_value' );
        can_ok( 'Cell', '_assess_value' );
        can_ok( 'Cell', 'clear' );
        can_ok( 'Cell', 'as_string' );
        can_ok( 'Cell', 'as_number' );
}

my $cell;
$cell = Cell->new('B5');

is(ref $cell, 'Cell',      'Correct input for cell ');

is($cell->row,     5,      'Correct cell row');
is($cell->column, 'B',     'Correct cell column');

ok(!$cell->value,          'Cell has a default empty/0 value' );
ok($cell->value == 0,      'Cell has a default 0 numeric value' );
ok($cell->value eq '',     'Cell has a default empty string value' );

ok($cell->as_string eq '', 'Correctly printed empty string value');
ok($cell->as_number == 0,  'Correctly printed zero numeric value');

$cell->value(5.12);
ok($cell->value == 5.12,   'Cell has a correct numeric value' );

$cell->clear;
ok(!$cell->value,          'Cell has a empty/0 value' );
ok($cell->value == 0,      'Cell has 0 numeric value' );
ok($cell->value eq '',     'Cell has an empty string value' );

undef $cell;
eval {
    $cell = Cell->new('5B');
};
like ($@, qr/does not pass the type constraint/, 'Incorrect input for cell creation');
isnt(ref $cell, 'Cell', 'Incorrect input (5B) for cell');

##-----------------------------------------------------------------------------------

my $mock_ss = Test::MockObject->new();
$mock_ss->set_isa('Spreadsheet');
my $mock_obj = Test::MockObject->new();
$mock_obj->fake_new( 'Range' );

$mock_obj->mock('_gather_cell_values', sub { say 'mocking _gather_cell_values' });
$mock_obj->mock('_gather_positions',   sub { say 'mocking _gather_positions'   });
$mock_obj->mock('SUM', sub { return 10 ;});

$cell = Cell->new('A2');
$cell->spreadsheet($mock_ss);
$cell->value('=SUM(A1:B2)');

is($cell->calc_value, 10, 'Correct output for cell value when setting a function');
is($cell->as_string, '=SUM(A1:B2)', 'Correct string output for cell value when setting a function');
is($cell->as_number,  10,           'Correct number output for cell value when setting a function');

eval {
    $cell->value('=SUM(AAAA)');
};
like($@, qr/Error/, 'Correct failure for incorrect limits input (=SUM(AAAA)) for _assess_value');

eval {
    $cell->value('=SUM(ABCD:)');
};
like($@, qr/Error/, 'Correct failure for incorrect limits input (=SUM(AAAA:)) for _assess_value');

eval {
    $cell->value('=SUM(AB:22)');
};
like($@, qr/Error/, 'Correct failure for incorrect limits input (=SUM(AB:22)) for _assess_value');

eval {
    $cell->value('=sum(A1:C2)');
};
like($@, qr/Error/, 'Correct failure for incorrect limits input (=sum(A1:C2)) for _assess_value');

eval {
    $cell->value('=S5D(A1:C2)');
};
like($@, qr/Error/, 'Correct failure for incorrect limits input (=S5D(A1:C2)) for _assess_value');


done_testing();


