use utf8;
package VotingPoll::Schema::VotingPollDB::Result::Constituency;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

VotingPoll::Schema::VotingPollDB::Result::Constituency

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

=head1 TABLE: C<constituency>

=cut

__PACKAGE__->table("constituency");

=head1 ACCESSORS

=head2 id

  data_type: 'smallint'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 county

  data_type: 'smallint'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "smallint", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "county",
  { data_type => "smallint", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name>

=over 4

=item * L</name>

=item * L</county>

=back

=cut

__PACKAGE__->add_unique_constraint("name", ["name", "county"]);

=head1 RELATIONS

=head2 constituency_parties

Type: has_many

Related object: L<VotingPoll::Schema::VotingPollDB::Result::ConstituencyParty>

=cut

__PACKAGE__->has_many(
  "constituency_parties",
  "VotingPoll::Schema::VotingPollDB::Result::ConstituencyParty",
  { "foreign.constituency" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 county

Type: belongs_to

Related object: L<VotingPoll::Schema::VotingPollDB::Result::County>

=cut

__PACKAGE__->belongs_to(
  "county",
  "VotingPoll::Schema::VotingPollDB::Result::County",
  { id => "county" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 voting_stats

Type: has_many

Related object: L<VotingPoll::Schema::VotingPollDB::Result::VotingStat>

=cut

__PACKAGE__->has_many(
  "voting_stats",
  "VotingPoll::Schema::VotingPollDB::Result::VotingStat",
  { "foreign.constituency" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-04-01 22:51:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GBuYiAfyGcKtjjiCfTmSKQ

__PACKAGE__->many_to_many(
  "parties",
  "constituency_parties", "party"
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
