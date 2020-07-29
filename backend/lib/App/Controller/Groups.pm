package App::Controller::Groups;

use Modern::Perl;
use Dancer2 appname => 'App';

use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Routes;
use Dancer2::Plugin::Permissions;

register_permission 'groups_list', 'create_group', 'edit_group', 'delete_group';

register_route {
    method => 'post',
    regexp => '/groups/list',
    code => has_permission 'groups_list', sub {
        my $groups_model = rset('Group');
        my @groups = $groups_model->all();
        return {
            groups => [
                map { $_->TO_JSON } @groups
            ]
        };
    }
};

register_route {
    method => "post",
    regexp => "/groups/add",
    code => has_permission 'create_group', sub {
        my $group_data = request->data->{group};
        my $groups_model = rset('Group');
        my $validator = $groups_model->validator();
        my $valid_data = $validator->validate( $group_data );
        my $errors = $validator->get_errors();

        if( $errors ){
            return {
                error => "Failed params",
                params => $errors
            }
        } else {
            $groups_model->create($valid_data);
            return {
                success => 1
            }
        }
    }
};

register_route {
    method => 'post',
    regexp => '/groups/edit',
    code => has_permission 'edit_group', sub {
        my $group_data = request->data->{group};
        my $groups_model = rset('Group');
        my $validator = $groups_model->validator( skip_name => 1 );
        my $valid_data = $validator->validate( $group_data );
        my $errors = $validator->get_errors();

        if( $errors ){
            return {
                error => "Failed params",
                params => $errors
            }
        } else {
            my $name = delete $group_data->{name};
            unless(keys(%{$group_data})){
                return {
                    error => "Nothing to update"
                }
            }
            my $group = $groups_model->find({name => $name});
            unless($group){
                return {
                    error => "Group not found"
                }
            }

            $group->update($group_data);
            return {
                success => 1
            }
        }
    }
};

register_route {
    method => 'post',
    regexp => '/groups/delete',
    code => has_permission 'delete_group', sub {
        my $groups_model = rset('Group');
        my $name = request->data->{name};
        unless( $name ){
            return {
                error => "Group not found"
            }
        }

        my $group = $groups_model->find({name => $name});
        unless($group){
            return {
                error => "Group not found"
            }
        }

        if( $group->users->all ){
            return {
                error => "Can't remove group with users"
            }
        }

        $group->delete;
        return {
            success => 1
        }
    }
};

register_route {
    method => "post",
    regexp => "/group/permissions/list",
    code => has_permission 'edit_group', sub {

    }
};

register_route {
    method => "post",
    regexp => "/group/permissions/set",
    code => has_permission 'edit_group', sub {

    }
};

1;
