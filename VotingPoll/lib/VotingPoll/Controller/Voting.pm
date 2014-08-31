package VotingPoll::Controller::Voting;
use Moose;
use namespace::autoclean;

use v5.14;
use FindBin qw($Bin);
use lib "$Bin/../..";

say $Bin;

use Data::Dumper qw(Dumper);

use VotingPoll::Controller::Helper::Voting qw(
                                              get_vote_results
                                              get_counties_info
                                              get_parties_info
                                              store_yes_vote
                                              get_current_stats4constituency
                                              create_results_chart
                                              get_chart_config
                                             );

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

VotingPoll::Controller::Voting - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head3 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    #$c->response->body('Matched VotingPoll::Controller::Voting in Voting.');
    $c->forward("/voting/poll");
}

=head3 

=cut

sub poll :Chained('/') PathPart('voting/poll') Args(0) {
    my ( $self, $c ) = @_;

    my ($national_results, $chart_config);
    $national_results = get_vote_results($c);

print STDERR Dumper($national_results);

    $c->stash->{national_results} = $national_results;

    $chart_config = get_chart_config($c);
    $c->stash->{nationalResultsCallback} = create_results_chart($chart_config, $national_results);
    #$c->stash->{constit_results_chart}  = create_results_chart('constit_results_chart', $constit_results);

    $c->stash->{template} = 'poll.tt';
}

=head3 get_counties

JSON call to populate county menu on demand

caches county and constituency data 

=cut

sub get_counties :Local Args(0) {
    my ( $self, $c ) = @_;

    my ($counties);
    $counties = get_counties_info($c);

    $c->stash->{ counties } = $counties;

    $c->forward('View::JSON');
    
}

=head3 get_constituencies

=cut

sub get_constituencies :Local Args(1) {
    my ( $self, $c, $const_id ) = @_;

    my ($counties, $constituencies);

    $counties         = get_counties_info($c);
    $constituencies = $counties->{ $const_id }{ constituencies };

    $c->stash->{ constituencies } = $constituencies;
    
    $c->forward('View::JSON');
    
}

sub get_parties :Local Args(1) {
    my ( $self, $c, $constituency ) = @_;

    my ($parties);

    $parties = get_parties_info($c, $constituency);

    $c->stash->{ parties } = $parties;
    
    $c->forward('View::JSON');
    
}

sub store_nu_vote :Chained('/') PathPart('voting/store_nu_vote') Args(1) {
    my ($self, $c, $answer) = @_;

    return unless $answer eq 'No' || $answer eq 'Undecided';

    eval {
        $c->model('VotingPoll::YesNoVoting')->create({ votes => $answer});
    };
}

sub store_vote :Chained('/') PathPart('voting/store_vote') Args(2) {
    my ($self, $c, $constituency, $party) = @_;

    my $vote = {
                    constituency => $constituency,
                    party        => $party,
               };

    my $success = store_yes_vote($c, $vote);

    $c->stash->{ error } = 'We are very sorry. There was a problem with storing your vote. Please try again.' unless $success;

    $c->forward('View::JSON');
}

sub get_vote_stats :Local Args() {
    my ($self, $c, $const) = @_;

    undef $const if $const eq 'undefined';

    my $results = get_vote_results($c, $const);

    #say "==================================";
    #say STDERR Dumper($results);
    #say ref $results;
    #say "==================================";

    $c->stash->{results}      = $results;
    $c->stash->{chart_config} = get_chart_config($c, $const);

    $c->forward('View::JSON');
}

=head1 AUTHOR

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
