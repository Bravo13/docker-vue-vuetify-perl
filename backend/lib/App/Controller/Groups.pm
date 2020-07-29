package App::Controller::Groups;

use Modern::Perl;
use Dancer2 appname => 'App';

use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Routes;
use Dancer2::Plugin::Permissions;

register_permission 'groups_list', 'create_group';

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
    code => has_permission 'add_group', sub {
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

1;
