package App::Controller::Permissions;

use Modern::Perl;
use Dancer2 appname => 'App';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Routes;
use Dancer2::Plugin::Permissions;

register_permission 'list_permissions';

register_route {
    method => 'post',
    regexp => '/permissions/list',
    code => has_permission 'list_permissions', sub {
        return {
            permissions => [
                map {$_->TO_JSON} rset('Permission')->all
            ]
        }
    }
};

1;
