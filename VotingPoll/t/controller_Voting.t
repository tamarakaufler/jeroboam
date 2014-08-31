use strict;
use warnings;
use Test::More;


use Catalyst::Test 'VotingPoll';
use VotingPoll::Controller::Voting;

ok( request('/voting')->is_success, 'Request should succeed' );
done_testing();
