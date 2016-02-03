#!/usr/bin/perl
#--------------------------
#Writer : Mico Cheng
#Version: 20050608
#Use for: Accounting mails
#Host   : mail 2000 system
#--------------------------
use Net::SMTP;

if ($#ARGV ne 0) {
    print "\nUsage: mail_statistics.pl <yesterday|20050603>\n\n";
    exit 1;
}

$localtime = shift;
$basedir_log_archive = '/webmail/log_archive/';

if ($localtime == 'yesterday') {
    chomp($localtime = `date +%Y%m%d`);
    --$localtime;
}

$year = substr($localtime,0,4);
$month = substr($localtime,4,2);
$date = substr($localtime,6,2);

$report_file = "/home/webmail/mico/report/mail_statistics."."$localtime";
#----------------------------------------------------
$dir2 = sprintf "%4d_%02d/",$year, $month;
$log_archive_file = sprintf "mailerd.log.%02d%02d%02d", substr($year,2,2), $month, $date;
$ab_log_archive = "$basedir_log_archive"."$dir2"."$log_archive_file\n";


open FH,"$ab_log_archive" or die " can't open $ab_log_archive $!\n";

while (<FH>) {
    chomp;
    $rl++ if (/Mail.RL/); 
    $ll++ if (/Mail.LL/); 
    $lr++ if (/Mail.LR/); 
    $rr++ if (/Mail.RR/); 
}
$total = $rl+$ll+lr+rr;
close(FH);

open FH2,"> $report_file" or die " Can't create $report_file:$!\n";

print FH2 "Date: $localtime\n";
print FH2 "File: $ab_log_archive\n\n";
print FH2 "Mail.RL = $rl\n";
print FH2 "Mail.LL = $ll\n";
print FH2 "Mail.LR = $lr\n";
print FH2 "Mail.RR = $rr\n";
print FH2 "Total = $total\n";
close(FH2);
