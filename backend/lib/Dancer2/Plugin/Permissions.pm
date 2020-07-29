package Dancer2::Plugin::Permissions;

use Modern::Perl;
use Dancer2::Plugin;

sub BUILD {
    my $plugin = shift;

    my $app = $plugin->app;
    my $dsl = $plugin->dsl;

    $app->add_hook(
        Dancer2::Core::Hook->new(
            name => 'before',
            code => on_request($dsl)
        )
    )
}

sub on_request {
    my $dsl = shift;
    return sub {
        my $app = shift;

        $dsl->debug("Checking token session");
        if(
            not $app->request->data
            or not $app->request->data->{token}
        ){
            $dsl->debug("No data in request or no token in data");
            return;
        }

        my $db = $app->find_plugin('Dancer2::Plugin::DBIC');
        unless($db){
            $dsl->error("No connection to db");
            halt("No DB");
        }

        my $token = $app->request->data->{token};

        my $session = $db->rset('Token')->search({
            token => $token,
            '-or' => {
                expire_time => { '>' => time },
                type => 'third_parties'
            }
        })->first;
        if($session){
            $dsl->var(session => $session);
            $dsl->debug($session->user->email);
        } else {
            $dsl->debug("No records for token $token")
        }
    }
}

register 'has_permission' => sub {
    my $plugin = shift;
    my ( $permission, $next ) = @_;
    return sub {
        my $app = shift;

        my $access_denied = sub {
            $app->response->status(400);
            return { error => 'Access denied'};
        };
        my $session = $app->request->var('session');
        return $access_denied->() unless $session;
        return $access_denied->() unless $session->user;
        return $access_denied->() unless $session->user->group;
        return $access_denied->() unless $session->user->group->has_permission($permission);
        return $next->($app);
    }
};

register 'register_permission' => sub {
    my $dsl = shift;
    my $permission = shift;

    my $app = $dsl->app;

    my $db = $app->find_plugin('Dancer2::Plugin::DBIC');
    unless($db){
        die "Can't find database plugin";
    }

    my $model = $db->resultset('Permission');
    my $obj = $model->find_or_create({ name => $permission, module => ((caller(1))[0]) });
};

register_plugin;

1;
