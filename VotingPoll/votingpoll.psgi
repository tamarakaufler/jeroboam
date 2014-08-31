use strict;
use warnings;

use VotingPoll;

my $app = VotingPoll->apply_default_middlewares(VotingPoll->psgi_app);
$app;

