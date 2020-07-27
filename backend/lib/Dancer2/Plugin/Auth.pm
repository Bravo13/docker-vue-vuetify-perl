package Dancer2::Plugin::Auth;

use Modern::Perl;
use Syntax::Keyword::Try;
use Dancer2::Plugin;

sub BUILD {
    my $plugin = shift;
    my $app = $plugin->app;
    my $dsl = $plugin->dsl;

    my $routes  = $plugin->find_plugin('Dancer2::Plugin::Routes')
        or $dsl->send_error('Could not find Routes');

    $routes->register_route({
        code => sub { return { authok => 1}},
        regexp => '/auth/google',
        method => 'post'
    });

    $routes->register_route({
        code => \&generate_token,
        regexp => '/auth/phone',
        method => 'post'
    });
};

sub generate_token {
    my $app = shift;
    my $schema = $app->find_plugin('Dancer2::Plugin::DBIC');
    my $message;
    unless($schema){
        return { error => "No database connection"}
    }

    my $token_model = $schema->resultset('Token');
    $message .= ref($token_model);
    $message .= $token_model->generate_token;
    my $result = $token_model->create_new(
        owner_id => 1,
        expire_time=> time + 24 * 60 * 60,
        type => 'user'
    );
    $message .= ref($result);

    return {
        messsage => $result->token
    }
}
1;