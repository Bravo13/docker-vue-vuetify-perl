package App::Controller::Permissions;

use Modern::Perl;
use Dancer2 appname => 'App';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Routes;

register_route {
    method => 'post',
    regexp => '/permissions/list',
    code => sub {
        return [
            map {$_->TO_JSON} rset('Permission')->all
        ]
    }
};

1;
