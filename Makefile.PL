use inc::Module::Install;

RTx     'RT-Extension-PagerDuty';
license 'MIT';
repository 'https://github.com/sdickenson/RT-Extension-PagerDuty';

requires_rt '4.0.0';
rt_too_new '4.4.2';

sign;
WriteAll;
