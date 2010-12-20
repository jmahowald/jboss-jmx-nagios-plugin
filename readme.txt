-------- Jboss JMX plugin for Nagios ---------


-------- Installation ---------

cpan
install Class::Accessor Config::Tiny Math::Calc::Units Params::Validate

wget http://cpan.uwinnipeg.ca/cpan/authors/id/T/TO/TONVOON/Nagios-Plugin-0.35.tar.gz
tar xzf Nagios-Plugin-0.35.tar.gz 

perl Makefile.PL
make
make test
make install



-------- Check Installation ---------

Run /usr/lib/nagios/plugins/check_jmx -help to see available options

Try run some command, for example:
/usr/lib/nagios/plugins/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:1616/jmxrmi -O java.lang:type=Memory -A HeapMemoryUsage -K used -I HeapMemoryUsage -J used -vvvv -w 10000000 -c 100000000

(replace 1616 with your JMX port)

This must return something like:

JMX OK HeapMemoryUsage=7715400{committed=12337152;init=0;max=66650112;used=7715400}

-------- Configuration ---------

To see available options use
/usr/lib/nagios/plugins/check_jmx -help

