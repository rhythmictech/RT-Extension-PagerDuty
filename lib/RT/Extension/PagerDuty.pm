use strict;
use warnings;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use JSON;
package RT::Extension::PagerDuty;

our $VERSION = '0.01';

=head1 NAME

RT-Extension-PagerDuty - Integration with PagerDuty webhooks

=head1 DESCRIPTION

This module is designed for *Request Tracker 4* integrating with *PagerDuty* webhooks.

=head1 RT VERSION

Works with RT 4.2.0

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

If you are using RT 4.2 or greater, add this line:

    Plugin('RT::Extension::PagerDuty');

For RT 4.0, add this line:

    Set(@Plugins, qw(RT::Extension::PagerDuty));

or add C<RT::Extension::PagerDuty> to your existing C<@Plugins> line.

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

Andrew Wippler E<lt>andrew.wippler@gmail.comE<gt>
Steven Dickenson E<lt>sdickenson@gmail.comE<gt>

=head1 BUGS

=head1 LICENSE AND COPYRIGHT

The MIT License (MIT)

Copyright (c) 2017 Steven Dickenson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



=cut
sub Notify {
	my %args = @_;

  my $payload = {
    service_key => $args{service_key},
    event_type => 'trigger',
    incident_key => $args{incident_key},
    description => $args{description},
    client => 'Request Tracker',
    client_url => $args{client_url},
  };

	my $payload_json = JSON::encode_json($payload);

	my $service_webhook;
	$service_webhook = 'https://events.pagerduty.com/generic/2010-04-15/create_event.json';

	my $ua = LWP::UserAgent->new();
	$ua->timeout(10);

	$RT::Logger->info('Pushing notification to PagerDuty: '. $payload_json);
	my $response = $ua->post($service_webhook,[ 'payload' => $payload_json ]);
	if ($response->is_success) {
		return;
	} else {
		$RT::Logger->error('Failed to push notification to PagerDuty ('.
		$response->code .': '. $response->message .')');
	}
}

1;
