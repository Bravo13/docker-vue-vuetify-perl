package Dancer2::Plugin::Notifications;

use Modern::Perl;
use Dancer2::Plugin;
use Dancer2::Plugin::RedisJobQueue;

use Task::SMS;

plugin_keywords 'send_sms';

sub send_sms {
    my $plugin = shift;
    my ($recipient, $type, %vars) = @_;

    my $jq = $plugin->app->find_plugin('Dancer2::Plugin::RedisJobQueue');
    unless($jq){
        die "Can't find RedisJobQueue plugin";
    }

    my $message = $plugin->app->template('notifications/sms/'.$type.'.tt', \%vars);

    $jq->add_task(
        recipient => $recipient,
        message => $message,
        class => 'Task::SMS',
    );
}

1;