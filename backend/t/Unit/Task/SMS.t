use FindBin;
use lib "$FindBin::Bin/../../../lib";
use Modern::Perl;
use Test::More;

use Dancer2::Template::TemplateToolkit;
use Task::SMS;

my $task = Task::SMS->new(
    type => 'auth',
    recipient => 'fake_recipient',
    message => 'test_message',
    config => {
        url => 'fake_url',
        token => 'fake_token',
        sender => 'fake_sender'
    },
);

is( ref($task), 'Task::SMS');
print $task->_build_send_xml();