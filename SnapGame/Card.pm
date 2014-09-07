package Card;
#===============================================================================
#
#         FILE: Card.pm
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
use feature         qw(say state switch);

use List::MoreUtils qw(any);
use Data::Dumper    qw(Dumper);

=head3 new

constructor: { suit  => 'heart' } 
             { value => 'J' } 

IN:     class
        suit
        value
OUT:    Card instance

=cut

sub new {
    my ($class, $suit, $value) = @_;

    die 'Needs to be a Card instance'                unless $class eq 'Card';
    die 'Invalid suit  (heart club diamond spade)'   unless any { $suit  =~ /\A$_\z/ } qw(heart club diamond spade);
    die 'Invalid value (2 3 4 5 6 7 8 9 10 J Q K A)' unless any { $value =~ /\A$_\z/ } qw(2 3 4 5 6 7 8 9 10 J Q K A);

    my $self = { value => $value,
                 suit  => $suit };
    use overload qw("") => sub { my $self = shift;
                                 return '[' . $self->{ suit } . ' - ' . $self->{ value } . ']' };

    bless $self, $class;
}

=head3 asString

prints the card information

IN:     Card object
OUT:    NA
        
=cut

sub asString {
    my ($self) = @_;
    
    say "Card: suit ... $self->{ suit }, value ... $self->{ value }";
} 

sub doesMatch {
    my ($self, $condition, $card) = @_;

    my $match;
    given ($condition) {
        when ( /\Avalue\z/ ) { $match = ($self->{value} eq $card->{value}) ? 1 : 0; }
        when ( /\Asuit\z/ )  { $match = ($self->{suit}  eq $card->{suit})  ? 1 : 0; }
        default              { $self->_doesMatch($card) }  
    }

    return $match;
}

sub _doesMatch {
    my ($self, $card) = @_;

    ( ($self->{value} eq $card->{value})
                      &&
      ($self->{suit}  eq $card->{suit}) ) ? return 1 : return 0;
    
}

1;
