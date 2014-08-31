use utf8;
package VotingPoll::Schema::VotingPollDB::Result::YesNoVoting;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

VotingPoll::Schema::VotingPollDB::Result::YesNoVoting

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<yes_no_voting>

=cut

__PACKAGE__->table("yes_no_voting");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 votes

  data_type: 'enum'
  extra: {list => ["Yes","No","Undecided"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "votes",
  {
    data_type => "enum",
    extra => { list => ["Yes", "No", "Undecided"] },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-04-01 22:51:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R9oHMJrXHmG4BcyFQ62pVw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
