package App;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Routes;
use Dancer2::Plugin::Auth;
use Dancer2::Plugin::Permissions;
use Dancer2::Plugin::RedisJobQueue;

any '/healthcheck' => sub {
    debug "healtcheck";
    return { healthcheck => "ok" };
};

any '/add_task' => sub {
    add_task('sms', { resipient => 'Kolya', data => { param => 'value'}});
    return {
        ok => 1
    }
};

any '/testt' => has_permission 'read_all' => sub {
    return {
        'success' => 1
    }
};

any '/test' => sub {
    my $users = rset('User');
    my $permissions = rset('Permission');
    my $user = $users->find({ id => 1});

    my $permission = $permissions->find({name => 'read_users'});
    my $permission2 = $permissions->find({name => 'read_all'});

    warning !!$user->group->has_permission('test');
    warning !!$user->group->has_permission('read_users');
    warning !!$user->group->has_permission($permission);
    warning !!$user->group->has_permission($permission2);

    return [
        map { 
            +{
                email => $_->email,
                group => {
                    name => $_->group->name,
                }
            }
        } $users->all()
    ]
};

1;