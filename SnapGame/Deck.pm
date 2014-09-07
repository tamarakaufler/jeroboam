package Deck;
#===============================================================================
#
#         FILE: Deck.pm
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
use feature    qw(say state);

use List::Util;

use Card;

sub new {
    my ($class, $packs) = @_;

    die 'Needs to be a Deck instance' unless $class eq 'Deck';

    $packs = 1 unless $packs;

    my $self           = {};
    $self->{ cards } = _create_deck($packs);

    bless $self, $class;

}

=head2 Instance methods

=head3 shuffle

=cut

sub shuffle {
    my ($self) = @_;

    $self->{ cards } = [ List::Util::shuffle @{$self->{ cards }} ];

}

=head3 deal

deals a card from the deck

IN:    
OUT:

=cut

sub deal {
    my ($self) = @_;

    pop @{$self->{ cards }};
}

=head2 Private helper methods

=cut

sub _create_deck {
    my ($packs) = @_;

    my @suits  = qw( heart club diamond spade);
    my @values = qw( 2 3 4 5 6 7 8 9 10 J Q K A );

    my @cards = ();
    for ( 1 .. $packs ) {
        for my $suit (@suits) {
            for my $value (@values) {
                push @cards, Card->new($suit, $value);    
            }
        }
    }

    return \@cards;
}

1;
