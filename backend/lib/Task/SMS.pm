package Task::SMS;

use Moo;
use XML::Simple;
use LWP::UserAgent;
use Data::Dumper;

has type => (
    'is' => 'rw',
);

has message => (
    'is' => 'rw',
);

has recipient => (
    'is' => 'rw',
);

has config => (
    'is' => 'ro'
);

has xml => (
    'is' => 'rw'
);

sub BUILD {
    my $self = shift;
    $self->xml(XML::Simple->new);
}

sub run {
    warn 'processing';
    my $self = shift;
    
    my $xml = $self->_build_send_xml();
    my $ua = LWP::UserAgent->new();
    my $result = $ua->post($self->config->{url}, content => $xml);
    unless($result->is_success){
        warn "Request result not success";
        warn $result->content;
        return 1;
    }

    my $response = $self->xml->XMLin($result->content);
    if($response->{error}){
        warn Dumper($xml);
        warn Dumper($response);
        warn Dumper($result->content);
        return $response->{error};
    }
    return 0;
}

sub _build_send_xml {
    my $self = shift;
    my $xml_data = {
        package => {
            key => $self->config->{token},
            message => {
                msg => [
                    {
                        recipient => $self->recipient,
                        sender => $self->config->{sender},
                        content => $self->message
                    }
                ]
            }
        }
    };

    return $self->xml->XMLout($xml_data, KeepRoot => 1, XMLDecl => '<?xml version="1.0" encoding="utf-8" ?>');
}

1;