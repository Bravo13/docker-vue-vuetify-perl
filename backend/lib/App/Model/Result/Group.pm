use utf8;
package App::Model::Result::Group;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Model::Result::Group

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<groups>

=cut

__PACKAGE__->table("groups");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_UNIQUE>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name_UNIQUE", ["name"]);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-07-30 02:18:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UvIUVh6RSjRG3wJkO97LeQ


__PACKAGE__->has_many('group_permissions' => 'App::Model::Result::GroupPermission', 'group_id');
__PACKAGE__->has_many('users' => 'App::Model::Result::User', 'group_id');
__PACKAGE__->many_to_many('permissions' => 'group_permissions', 'permission_id');

sub has_permission {
  my $self = shift;
  my $permission = shift;
  my $id = !ref($permission) ? $permission : $permission->name;
  return !! grep { $_->name eq $id } $self->permissions();
}

sub TO_JSON {
    my $self = shift;
    return {
        id => $self->id,
        name => $self->name,
        description => $self->description
    }
}
1;
