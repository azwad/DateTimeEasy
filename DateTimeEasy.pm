package DateTimeEasy;
use strict;
use warnings;
use utf8;
use DateTime::Format::HTTP;
use DateTime::Format::Mail;
use DateTime::Format::SQLite;
use DateTime::Format::RFC3501;
use DateTime::Format::RFC3339;
use DateTime::Format::W3CDTF;
use DateTime;
use Encode;
use Time::Local qw( timelocal );
use Date::Manip qw ( UnixDate);
use feature 'say';
use base qw (Exporter);
use Carp 'croak';
#use lib '/home/toshi/perl/lib';
#use Pause qw( pause );

our @EXPORT = qw ( datestr );

sub datestr {
	croak "usage: datestr(timstr,option). you might be use 'localtime'? " if (@_ >2) ;
	my ($time_strings, $output_option) = @_;
	$time_strings = Encode::decode_utf8($time_strings);
#	say $time_strings;

	if ( $time_strings =~ /(年|月|日)/  && $time_strings =~/(時|分)/ && $time_strings !~/秒/ ) {
		$time_strings =~ /(\d+)\D+(\d+)\D+(\d+)\D+\s+?(\d+)\D+(\d+)\D+(\d?)\D?/;
		$time_strings = sprintf ("%04d-%02d-%02d %02d:%02d", $1,$2,$3,$4,$5);
#		say 'pattern 1';
#		pause;	
	}elsif ( $time_strings =~ /(年|月|日)/  && $time_strings =~/(時|分)/ && $time_strings =~/秒/){
		$time_strings =~ /(\d+)\D+(\d+)\D+(\d+)\D+\s+?(\d+)\D+(\d+)\D+(\d+)\D?/;
		$time_strings = sprintf ("%04d-%02d-%02d %02d:%02d:%02d", $1,$2,$3,$4,$5,$6);
#		say 'pattern 2';
#		pause;	
	}elsif ($time_strings =~ /(年|月|日)/ ){
		$time_strings =~ /(\d+)\D+(\d+)\D+(\d+)\D+/;
		$time_strings = sprintf ("%04d-%02d-%02d", $1,$2,$3);
#		say 'pattern 3';
#		pause;	
	}elsif($time_strings =~ s/(\d{4}\D\d{1,2}\D\d{1,2}\s+?\d{1,2}\D\d{1,2}\D\d{1,2})/$1/){
		$time_strings = $1;
#		say 'pattern 4';
#		pause;	
	}elsif($time_strings =~ s/(\d{4}\D\d{1,2}\D\d{1,2}\s+?\d{1,2}\D\d{1,2})/$1/){
		$time_strings = $1;
#		say 'pattern 5';
#		pause;	
	}elsif($time_strings =~ s/(\d{4}\D\d+\D\d+\s+?\d+\D\d+\D\d+)/$1/){
		$time_strings = $1;
#		say 'pattern 6';
#		pause;	
	}elsif($time_strings =~ /^\d+\D+\d+\D+\d+/ ){
		$time_strings =~ /(\d+)\D+(\d+)\D+(\d+)/;
		my ($a,$b,$c);
		$a = $b = $c = '%02d';
		$1>100 ? $a = '%04d':
		$2>100 ? $b = '%04d':
		$3>100 ? $c = '%04d':
		undef;
		$time_strings = sprintf ("$a-$b-$c", $1,$2,$3);
#		say 'pattern 7';
#		pause;	
	}
#say $time_strings;

#pause;
	
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
		}elsif (/epoch_sec/) {
			my $sec = $dt->second;
			my $min = $dt->minute;
			my $hour = $dt->hour;
			my $mday = $dt->day;
			my $month = $dt->month - 1;
			my $year = $dt->year - 1900;
			my $sec_from_epoch = timelocal( $sec, $min, $hour, $mday, $month, $year );
			return $sec_from_epoch;
		}else{
			return $dt->strftime( $_ );
		}
	}else{
		return $dt ;#return DateTime Instance
	}
}
1;

