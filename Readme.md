Jboss JMX Nagios Plugin
============
by Josh Mahowad <jmahowald@angel.com>

*Puts wrapper around twiddle to get simple output for a nagios plugin

Installation
------------
- install dependencies

cpan
install Class::Accessor Config::Tiny Math::Calc::Units Params::Validate

`wget http://cpan.uwinnipeg.ca/cpan/authors/id/T/TO/TONVOON/Nagios-Plugin-0.35.tar.gz`
`tar xzf Nagios-Plugin-0.35.tar.gz` 

`cd Nagios-Plugin-0.35`
`perl Makefile.PL`
`make`
`make test`
`make install`

- Add jboss/bin to path

Usage
------------

`jboss_twiddle_nagios.pl  -w 100 -c 1000000000  -H <host> -u <username> -p <password> -m jboss.system:type=ServerInfo -a FreeMemory`
JBOSS_TWIDDLE_NAGIOS WARNING - 800345504
