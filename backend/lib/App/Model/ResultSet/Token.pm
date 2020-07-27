package App::Model::ResultSet::Token;

use Modern::Perl;

use base 'DBIx::Class::ResultSet';

use Digest::MD5 qw(md5_hex);
sub generate_token {
    my $self = shift;
    return md5_hex(time + rand);
}

sub create_new {
    my $self = shift;
    my %args = @_;
    return $self->create({
        token => $self->generate_token,
        %args
    });
}

1;