use utf8;
package VotingPoll::Schema::VotingPollDB::Result::ConstituencyParty;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

VotingPoll::Schema::VotingPollDB::Result::ConstituencyParty

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

=head1 TABLE: C<constituency_party>

=cut

__PACKAGE__->table("constituency_party");

=head1 ACCESSORS

=head2 id

  data_type: 'smallint'
  is_auto_increment: 1
  is_nullable: 0

=head2 constituency

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=head2 party

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "smallint", is_auto_increment => 1, is_nullable => 0 },
  "constituency",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
  "party",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<constituency>

=over 4

=item * L</constituency>

=item * L</party>

=back

=cut

__PACKAGE__->add_unique_constraint("constituency", ["constituency", "party"]);

=head1 RELATIONS

=head2 constituency

Type: belongs_to

Related object: L<VotingPoll::Schema::VotingPollDB::Result::Constituency>

=cut

__PACKAGE__->belongs_to(
  "constituency",
  "VotingPoll::Schema::VotingPollDB::Result::Constituency",
  { id => "constituency" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 party

Type: belongs_to

Related object: L<VotingPoll::Schema::VotingPollDB::Result::Party>

=cut

__PACKAGE__->belongs_to(
  "party",
  "VotingPoll::Schema::VotingPollDB::Result::Party",
  { id => "party" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-04-01 22:51:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:znN/iX1B+3g8QdNo3zP86Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
