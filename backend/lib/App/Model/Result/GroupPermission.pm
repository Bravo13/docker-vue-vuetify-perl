use utf8;
package App::Model::Result::GroupPermission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Model::Result::GroupPermission

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<group_permissions>

=cut

__PACKAGE__->table("group_permissions");

=head1 ACCESSORS

=head2 group_id

  data_type: 'integer'
  is_nullable: 0

=head2 permission_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "group_id",
  { data_type => "integer", is_nullable => 0 },
  "permission_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<group_permission>

=over 4

=item * L</group_id>

=item * L</permission_id>

=back

=cut

__PACKAGE__->add_unique_constraint("group_permission", ["group_id", "permission_id"]);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2020-07-27 21:09:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DDAFrn6YySJwnAJZvRJdQQ


__PACKAGE__->belongs_to('group_id' => 'App::Model::Result::Group');
__PACKAGE__->belongs_to('permission_id' => 'App::Model::Result::Permission');
1;
