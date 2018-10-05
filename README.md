# RT-Extension-PagerDuty
Integration with PagerDuty webhooks

# DESCRIPTION
This module is designed for *Request Tracker 4* integrating with *PagerDuty* webhooks. 

# RT VERSION
Works with RT 4.2.0 and newer

# INSTALLATION
    perl Makefile.PL
    make
    make install

May need root permissions

Edit your /opt/rt4/etc/RT_SiteConfig.pm
If you are using RT 4.2 or greater, add this line:

	Plugin('RT::Extension::PagerDuty');

For RT 4.0, add this line:

	Set(@Plugins, qw(RT::Extension::PagerDuty));

Clear your mason cache
		rm -rf /opt/rt4/var/mason_data/obj

Restart your webserver

# CONFIGURATIONS

Edit your /opt/rt4/etc/RT_SiteConfig.pm to include: Set($PagerDutyApiToken, "pagerduty-v1-api-token");

# USAGE

Basic scrip use. Add this code to your scrip.

```
my $ticket = $self->TicketObj;

my $client_url = RT->Config->Get("WebURL")."Ticket/Display.html?id=".$ticket->id;
my $service_key = "0000000000000000000000000000000";
my $incident_key = "RT:".$ticket->id;
my $description = $ticket->Subject;

RT::Extension::PagerDuty::Notify(service_key => $service_key, incident_key => $incident_key, description => $description, client_url => $client_url);
```


# AUTHORS
Steven Dickenson (https://github.com/sdickenson/RT-Extension-PagerDuty)


# LICENSE AND COPYRIGHT
		Copyright 2018 Steven Dickenson

		Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License.
		You may obtain a copy of the License at

			http://www.apache.org/licenses/LICENSE-2.0

		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
		limitations under the License.
