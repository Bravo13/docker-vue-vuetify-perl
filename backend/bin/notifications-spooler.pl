#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";
use Modern::Perl;
use Dancer2;
use Dancer2::Plugin::RedisJobQueue;
use Task::SMS;
use Syntax::Keyword::Try;

debug 'Starting';

while ( my $job = jq->get_next_job(
        queue       => jq_queue,
        blocking    => 1,
    ) ) {
    $job->status( 'working' );
    jq->update_job( $job );
 
    # do my stuff
    debug 'New job';
    my $payload = ${$job->workload};
    debug $payload;
    try {
        $payload = decode_json($payload);
    } catch {
        error "Unable to decode job ".$job->id."payload: $@";
        $job->status( 'failed' );
        $job->queue( jq_failed_queue );
        jq->update_job( $job );
        next;
    }
    
    my ($class, $path);
    $class = $path =  $payload->{class};
    $path =~ s/::/\//g;
    $path .= '.pm';
    my $task;
    try {
        require $path;
        $task = $class->new(%{$payload}, config => config->{plugins}->{Notifications}->{sms});
    } catch {
        error "Failed to load class $class($path), reason:$@";
        $job->status( 'failed' );
        $job->queue( jq_failed_queue );
        jq->update_job( $job );
        next;
    }

    unless($task->can('run')){
        error "Task object has no 'run' method";
        $job->status( 'failed' );
        $job->queue( jq_failed_queue );
        jq->update_job( $job );
        next;
    }

    if(my $error = $task->run()){
        $job->status( 'failed' );
        error "Task $class run method returned $error";
    } else {
        debug 'Task run success';
        $job->status( 'completed' );
    }
    jq->update_job( $job );
}