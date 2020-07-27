use utf8;
package App::Model::Result::Token;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Model::Result::Token

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<tokens>

=cut

__PACKAGE__->table("tokens");

=head1 ACCESSORS

=head2 token

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 owner_id

  data_type: 'integer'
  is_nullable: 0

=head2 type

  data_type: 'enum'
  extra: {list => ["user","third_parties"]}
  is_nullable: 0

=head2 expire_time

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "token",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "owner_id",
  { data_type => "integer", is_nullable => 0 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["user", "third_parties"] },
    is_nullable => 0,
  },
  "expire_time",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</token>

=back

=cut

__PACKAGE__->set_primary_key("token");


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2020-07-26 14:05:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fiLw+Q7mM/8r5fDEpAIIVQ


__PACKAGE__->belongs_to('user' => 'App::Model::Result::User', 'owner_id');
1;
