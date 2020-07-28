package Dancer2::Plugin::RedisJobQueue;

use Modern::Perl;
use Dancer2::Plugin;
use Redis::JobQueue;
use JSON;

plugin_keywords 'jq', 'jq_queue', 'jq_failed_queue';

has jq => (
    is => 'ro',
    default => sub {
        my $config = $_[0]->app->config->{plugins}->{RedisJobQueue};
        Redis::JobQueue->new( redis => $config->{dsn} );
    }
);

has jq_queue => (
    is => 'ro',
    default => sub {
        my $config = $_[0]->app->config->{plugins}->{RedisJobQueue};
        return $config->{queue};
    }
);

has jq_failed_queue => (
    is => 'ro',
    default => sub {
        my $config = $_[0]->app->config->{plugins}->{RedisJobQueue};
        return $config->{failed_queue};
    }
);

sub add_task :PluginKeyword {
    my $plugin = shift;
    my (%job_data) = @_;

    my $config = $plugin->app->config->{plugins}->{RedisJobQueue};
    my $expire_config = $config->{expire} // {};
    $plugin->jq->add_job({
        queue => $config->{queue},
        workload => JSON::to_json(\%job_data),
        expire => $expire_config->{$job_data{type}} // 24*60*60
    });
}

register_plugin;

1;