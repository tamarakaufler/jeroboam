package VotingPoll::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION 	=> '.tt',
    render_die 			=> 1,

	WRAPPER      		=> 'site/wrapper',
);

=head1 NAME

VotingPoll::View::TT - TT View for VotingPoll

=head1 DESCRIPTION

TT View for VotingPoll.

=head1 SEE ALSO

L<VotingPoll>

=head1 AUTHOR

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
