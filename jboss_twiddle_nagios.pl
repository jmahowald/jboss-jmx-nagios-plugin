#!/usr/bin/perl

#!/usr/local/bin/perl

###  check_stuff.pl

# an example Nagios plugin using the Nagios::Plugin modules.  

# Originally by Nathan Vonnahme, n8v at users dot sourceforge
# dot net, July 19 2006

# Please modify to your heart's content and use as the basis for all
# the really cool Nagios monitoring scripts you're going to create.
# You rock.  

##############################################################################
# prologue
use strict;
use warnings;

use Nagios::Plugin ;

use vars qw($VERSION $PROGNAME  $verbose $warn $critical $timeout $result);
$VERSION = '1.0';

# get the base name of this script for use in the examples
use File::Basename;
$PROGNAME = basename($0);


##############################################################################
# define and get the command line options.
#   see the command line option guidelines at 
#   http://nagiosplug.sourceforge.net/developer-guidelines.html#PLUGOPTIONS


# Instantiate Nagios::Plugin object (the 'usage' parameter is mandatory)
my $p = Nagios::Plugin->new(
    usage => "Usage: %s [ -v|--verbose ]  -H <host> -u <username> -p <password> -m <mbean> -a <attribute>
    [ -c|--critical=<critical threshold> ] 
    [ -w|--warning=<warning threshold> ]  
    ",
    version => $VERSION,
    blurb => 'This plugin is an example of a Nagios plugin written in Perl using the Nagios::Plugin modules.  It will generate a random integer between 1 and 20 (though you can specify the number with the -n option for testing), and will output OK, WARNING or CRITICAL if the resulting number is outside the specified thresholds.', 

	extra => "

THRESHOLDs for -w and -c are specified 'min:max' or 'min:' or ':max'
(or 'max'). If specified '\@min:max', a warning status will be generated
if the count *is* inside the specified range.

See more threshold examples at http
  : // nagiosplug
  . sourceforge
  . net / developer-guidelines
  . html    #THRESHOLDFORMAT

  Examples:

  $PROGNAME -w 10 -c 18 Returns a warning
  if the resulting number is greater than 10,
  or a critical error
  if it is greater than 18.

  $PROGNAME -w 10 : -c 4 : Returns a warning
  if the resulting number is less than 10,
  or a critical error
  if it is less than 4.

  "
);


# Define and document the valid command line options
# usage, help, version, timeout and verbose are defined by default.

$p->add_arg(
	spec => 'warning|w=s',

	help => 
qq{-w, --warning=INTEGER:INTEGER
   Minimum and maximum number of allowable result, outside of which a
   warning will be generated.  If omitted, no warning is generated.},

#	required => 1,
#	default => 10,
);

$p->add_arg(
	spec => 'critical|c=s',
	help => 
qq{-c, --critical=INTEGER:INTEGER
   Minimum and maximum number of the generated result, outside of
   which a critical will be generated. },
);

$p->add_arg(
	spec => 'result|r=f',
	help => 
qq{-r, --result=INTEGER
   Specify the result on the command line rather than generating a
   random number.  For testing.},
);

$p->add_arg(
	spec => 'host|H=s',
	help => 
qq{-H, --host=name
   Specify the server to do this against.},
	required => 1
);


$p->add_arg(
	spec => 'username|u=s',
	help => 
qq{-u, --username=name
   Specify the username to login with.},
   required => 1
);

$p->add_arg(
	spec => 'password|p=s',
	help => 
qq{-p, --password=pasword
   Specify the password to use},
  required => 1
);

$p->add_arg(
	spec => 'mbean|m=s',
	help => 
qq{-m, --mbean=mbean description
   Specify the mbean to check},
	required => 1
);

$p->add_arg(
	spec => 'attribute|a=s',
	help => 
qq{-a, --attribute=attribute description
   Specify the attribute to check},
	required => 1
);

# Parse arguments and process standard ones (e.g. usage, help, version)
$p->getopts;


# perform sanity checking on command line options
if ( (defined $p->opts->result) && ($p->opts->result < 0 || $p->opts->result > 20) )  {
    $p->nagios_die( " invalid number supplied for the -r option " );
}

unless ( defined $p->opts->warning || defined $p->opts->critical ) {
	$p->nagios_die( " you didn't supply a threshold argument " );
}


unless ( defined $p->opts->host) {
	$p->nagios_die( " you didn't supply a host argument " );
}


unless ( defined $p->opts->username && (defined $p->opts->password)) {
	$p->nagios_die( " you didn't supply username and password " );
}

##############################################################################
# check stuff.

# THIS is where you'd do your actual checking to get a real value for $result
#  don't forget to timeout after $p->opts->timeout seconds, if applicable.
my $result;
my $host = $p->opts->host;
my $username = $p->opts->username;
my $password = $p->opts->password;
my $mbean = $p->opts->mbean;
my $attribute = $p->opts->attribute;


my $twiddle_result = `twiddle.sh -s $host -u $username -p $password get $mbean $attribute`;

print "Twiddle output was $twiddle_result " if $p->opts->verbose;

if($twiddle_result =~ /=(.*)/) {
	$result = $1;
}
else {
	$p->nagios_die( " didn't get expected output from twiddle $twiddle_result " );	
}


##############################################################################
# check the result against the defined warning and critical thresholds,
# output the result and exit
$p->nagios_exit( 
	 return_code => $p->check_threshold($result), 
	 message => " sample result was $result" 
);





