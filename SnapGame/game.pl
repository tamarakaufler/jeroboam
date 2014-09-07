#!/usr/bin/perl 
#===============================================================================
#
#         FILE: game.pl
#
#        USAGE: ./game.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use v5.18;
use utf8;
use feature qw(say state);
use Data::Dumper qw(Dumper);

use Deck;
use Snap;


#my $deck = Deck->new(2);
#
#for my $card (@{$deck->{ cards }}) {
#	$card->asString;
#}
#
#$deck->shuffle;
#my $i=0;
#for my $card (@{$deck->{ cards }}) {
#	print '*** ' . ($i+1)  . " [[ $card ]]" ; $card->asString;
#	$i++;
#}

#exit;
#====================================================

say 'How many packs? ';
my $packs = <STDIN>;
chomp $packs;

say 'Match type: value or suit or both : ';
my $match_type = <STDIN>;
chomp $match_type;

say 'Player names (comma separated) : ';
my $players = <STDIN>;
chomp $players;
my @players = split /\s*,\s*/, $players;

say '';

my $args = 	{
				packs 		 => $packs,
				match_type 	 => $match_type,
				player_names => \@players,
			};

my $snap = Snap->new($args);

$snap->setup;

$snap->play;





