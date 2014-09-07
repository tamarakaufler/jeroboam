#/usr/bin/perl 
#===============================================================================
#
#         FILE: game.pl
#
#        USAGE: ./game.pl  
#
#  DESCRIPTION: script for testing on top of the unit tests 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Tamara Kaufler
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 30/11/13
#     REVISION: ---
#===============================================================================

use v5.10;
use strict;
use warnings;
use utf8;

use Range;
use Cell;
use Spreadsheet;
use Data::Dumper qw(Dumper);

my $cell;
$cell = Cell->new('B3');
$cell->value(55.21);
say '!!! value = ' . $cell->value;
print 'as string ... ' . $cell->as_string . "\n";
print 'as number ... ' . $cell->as_number . "\n";

$cell->clear;
say '*** value = ' . $cell->value;
print 'as string ... ' . $cell->as_string. "\n";
print 'as number ... ' . $cell->as_number. "\n";

$cell->value(33.21);
say '+++ value = ' . $cell->value;
print 'as string ... ' . $cell->as_string. "\n";
print 'as number ... ' . $cell->as_number. "\n";


my $ss = Spreadsheet->new();
$ss->cell('A1')->value( 1 );
$ss->cell('A3')->value( 2 );
$ss->cell('A5')->value( 3 );
$ss->cell('B1')->value( 4 );
$ss->cell('E5')->value( 2 );
$ss->cell('H5')->value( '=SUM(D5:H8)' );
$ss->cell('H6')->value( 9.11 );
$ss->cell('H7')->value( 4.6 );
$ss->cell('B3')->value( 12.35 );
$ss->cell('C3')->value( 24.11 );
$ss->cell('C4')->value( '=COUNT(D5:H8)' );

say $ss->print;

$ss->cell('C4')->clear;
say 'value ' . $ss->cell('C4')->value;
say 'calc_value ' . $ss->cell('C4')->calc_value;
say 'as string ' . $ss->cell('C4')->as_string;
say 'as_number ' . $ss->cell('C4')->as_number;

$ss->cell('C4')->value( 11.2 );

say '===> ' .  $ss->cell('C4')->value;

my $range = Range->new(limits => 'D5:H8',  spreadsheet => $ss);
$cell->spreadsheet($ss);

say $range->SUM;
say $range->MIN;
say $range->MAX;
say $range->COUNT;

say $cell->value('=SUM(D5:H8)');
print 'as string ... ' . $cell->as_string. "\n";
print 'as number ... ' . $cell->as_number. "\n";

say $cell->value('=SUM(A5:A10)');
print 'as string ... ' . $cell->as_string. "\n";
print 'as number ... ' . $cell->as_number. "\n";


