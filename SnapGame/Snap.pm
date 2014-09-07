package Snap;
#===============================================================================
#
#         FILE: Snap.pm
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
use feature         qw(say state);

use List::MoreUtils qw(uniq);
use Data::Dumper    qw(Dumper);

use Player;
use Card;
use Deck;

=head3 new

IN:     class
        args hashref:
                        {   packs          => 3,
                            match_type      => 'suit',        # suit/value/both
                            player_names => [ qw[Ann Jim Dominic Tululah] ] 
                        } 
=cut

sub new {
    my ($class, $args) = @_;
    
    die 'Must be Snap class' unless $class eq 'Snap';
    ## TODO: other input checks ...

    my $self            = $args;
    $self->{players}    = { map { $_ , Player->new($_) } @{$self->{ player_names }}};

    $self->{run_cards}  = [];

    bless $self, $class;
}

=head3 setup

prepare the deck

=cut

sub setup {
    my ($self) = @_;

    die 'This needs to be a Snap object' unless ref $self eq 'Snap';

    my $deck = Deck->new( $self->{packs} );
    $deck->shuffle;
    $self->{deck} = $deck;
}

sub playCard {
    my ($self) = @_;

    my $card = $self->{deck}->deal or return;

    push @{$self->{run_cards}}, $card;

    return 1;

}

sub findWinner {
    my ($self) = @_;

    my @sorted_player_names = sort {
                                 scalar @{$self->{ players }{$b}{ cards}} 
                                                 <=>  
                                 scalar @{$self->{players }{$a}{ cards}}
                              }  keys %{$self->{players}};

    map {say "==> $_ has " . scalar @{$self->{ players }{ $_ }{ cards }}} @sorted_player_names;

    return $sorted_player_names[0];
    
}

sub play {
    my ($self) = @_;

    my ($played_card1, $played_card2);

    ## play the game
    ##--------------

    if ( not $self->playCard ) {
        say "Not enough cards to play ..."; 
        return;
    }

    my $snap_count = 0;
 
    while ( @{$self->{deck }{ cards}} ) {

        $self->playCard;

        if ( scalar @{$self->{run_cards}} < 2 ) {
            last unless $self->playCard;
        }

        $played_card1 = $self->{run_cards}[-1];
        $played_card2 = $self->{run_cards}[-2];

        ## We have a snap
        ##---------------
        if ($played_card1->doesMatch( $self->{match_type}, $played_card2 )) {
            $snap_count++;
            #say "\tS N A P";

            ## create random round winner
            ##---------------------------
            my $winner = $self->_getRandomWinner;

            push @{$winner->{cards }},@{$self->{ run_cards}} ;

            $self->{run_cards} = [];
        } 
    }

    if ($snap_count) {
        my $winner = $self->findWinner;
        say "+++ (snaps = $snap_count) Winner is    $winner with " , scalar @{$self->{players }{ $winner }{ cards}} . ' cards';
        say 'cards still on the run pile: ' . scalar @{$self->{run_cards}};
    }
    else {
        say "Bad luck - there could be no winners this time";
    }

}

=head3 _getRandomWinner

creates a random winner

IN:     Snap object
OUT:    player name

=cut

sub _getRandomWinner {
    my ($self) = @_;

    my $rand_index  = int(rand(scalar @{$self->{player_names}}));
    my $rand_name   = $self->{player_names}[$rand_index];
    my $rand_player = $self->{players}{$rand_name};

}

1;
