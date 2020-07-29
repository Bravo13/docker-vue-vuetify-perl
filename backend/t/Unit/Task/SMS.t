use FindBin;
use lib "$FindBin::Bin/../../../lib";
use Modern::Perl;
use Test::More;;
use Test::NoWarnings;

use Dancer2::Template::TemplateToolkit;
use Task::SMS;

plan tests => 3;

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
my $expected = q~<?xml version="1.0" encoding="utf-8" ?>
<package key="fake_token">
  <message>
    <msg recipient="fake_recipient" sender="fake_sender">test_message</msg>
  </message>
</package>
~;
is($task->_build_send_xml(), $expected);