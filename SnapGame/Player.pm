package Player;
#===============================================================================
#
#         FILE: Player.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
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

sub new {
    my ($class, $name) = @_;

    die 'Must be Player class' unless $class eq 'Player';

    my $self = { name   => $name,
                 cards  => [],
               };

    bless $self, $class;

}

1;
