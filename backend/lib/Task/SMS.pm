package Task::SMS;
use Mojo::Base 'Minion::Job';

sub run {
    my ($self, @args) = @_;
    warn 'JOB IS DONE';
}

1;