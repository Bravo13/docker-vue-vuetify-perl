package Dancer2::Plugin::UserAgent;

use Modern::Perl;
use Dancer2::Plugin;

use LWP::UserAgent;

has ua => (
    is => 'ro'
);

sub BUILD {
    my $self = shift;
    my $ua = LWP::UserAgent->new();
    
    my @methods = qw(post get);
    for my $method (@methods){
        plugin_keywords "send_$method" => sub {
            my $plugin = shift;
            return $ua->$method(@_);
        };
    }
};

1;
