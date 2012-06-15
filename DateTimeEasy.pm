package DateTimeEasy;
use strict;
use warnings;
use DateTime::Format::HTTP;
use DateTime::Format::Mail;
use DateTime::Format::SQLite;
use DateTime::Format::RFC3501;
use DateTime::Format::RFC3339;
use DateTime::Format::W3CDTF;
use DateTime;
use Date::Manip qw ( UnixDate);
use feature 'say';
use base qw (Exporter);
use Carp 'croak';

our @EXPORT = qw ( datestr );

sub datestr {
	croak "usage: datestr(timstr,option). you might be use 'localtime'? " if (@_ >2) ;
	my ($time_strings, $output_option) = @_;
	
	my ($year, $month, $day, $hour, $minute, $second ) = 
	 UnixDate( $time_strings, '%Y', '%m', '%d', '%H', '%M', '%S');

#why dosen't  Date::Manip	make correct DateTime Instance?

	my $dt = DateTime->new(
		time_zone => 'local',
		year => $year, month => $month, day => $day, 
		hour => $hour, minute => $minute, second => $second,
	);

	my $format_str = 'DateTime::Format::';

	$_ = $output_option;
	
	if (defined($_)){
		if (s/(HTTP|Mail|SQLite|RFC3501|RFC3339|W3CDTF)/$format_str$1/){ 
			return  $_->format_datetime($dt);
		}elsif (/(str|normal|standard)/) {
			return  $dt->strftime('%Y/%m/%d %H:%M:%S');
		}else{
			return $dt->strftime( $_ );
		}
	}else{
		return $dt ;#return DateTime Instance
	}
}
1;

