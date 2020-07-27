use utf8;
package App::Model::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Model::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 phone

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 group_id

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "phone",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "group_id",
  { data_type => "varchar", is_nullable => 1, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2020-07-27 21:09:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rjuwzymwsSeuA5E1Q8ssHg


__PACKAGE__->has_many('tokens' => 'App::Model::Result::Token', 'owner_id');
__PACKAGE__->belongs_to('group' => 'App::Model::Result::Group', 'group_id');

1;
