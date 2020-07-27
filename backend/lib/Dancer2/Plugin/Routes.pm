package Dancer2::Plugin::Routes;
use Modern::Perl;

use Dancer2::Plugin;
plugin_keywords 'register_route', 'registered_routes';

has routes_list => (
    is => 'rw',
    default => sub {
        return {};
    }
);

sub BUILD {
    my $plugin = shift;

    my $app = $plugin->app;
    my $dsl = $plugin->dsl;

    $plugin->register_route({
        regexp => '/routes/list',
        method => 'get',
        code => \&get_routes_list
    });
};

sub get_routes_list {
    my $app = shift;
    my $plugin = $app->find_plugin('Dancer2::Plugin::Routes');
    return [
        map { $_ } keys %{$plugin->routes_list}
    ];
}

sub register_route {
    my $plugin = shift;
    my @routes = @_;

    my $app = $plugin->app;
    my $dsl = $plugin->dsl;

    foreach my $route (@routes){
        $dsl->debug("Adding route ".$route->{regexp});
        $plugin->{routes_list}{$route->{regexp}} = $route;
        $plugin->app->add_route(%{$route});
    }
}

1;