#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";
use Modern::Perl;
use Dancer2;
use Dancer2::Plugin::RedisJobQueue;
use Task::SMS;

debug 'Starting';

while ( my $job = jq->get_next_job(
        queue       => jq_queue,
        blocking    => 1,
    ) ) {
    $job->status( 'working' );
    jq->update_job( $job );
 
    # do my stuff
    debug 'New job';
 
    $job->status( 'completed' );
    jq->update_job( $job );
}