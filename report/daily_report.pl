#!/usr/bin/perl
#--------------------------------------------------
#Writer : Mico Cheng
#Version: 2005060801
#Use for: daily report
#Hosts: any
#---------------------------------------------------
use Net::SMTP;

$smtp_server = '210.200.211.36';
$sender = 'mikocheng@aptg.com.tw';
@recipients = qw( mikocheng@aptg.com.tw );
foreach (@recipients) { $recipients=$recipients." ".$_};

chomp($localtime = `date +%Y%m%d`);
$report_path = "/home/webmail/mico/report/";
$report_file1 = "$report_path"."mail_backup_error.$localtime";
$report_file2 = "$report_path"."mail_statistics.20050607";

@monthNames = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
($date, $month, $year) = (localtime(time()))[3,4,5];
$year += 1900;

# Send mail by SMTP protocol
$smtp = Net::SMTP->new($smtp_server, Timeout=>60);
$smtp->mail($sender);
$smtp->recipient(@recipients,{SkipBad=>1});
$smtp->data;
#
## Header
$smtp->datasend("Date: @monthNames[$month] $date $year (Reports Generated)");
$smtp->datasend("From: ".$sender."\n");
$smtp->datasend("To: ".$recipients."\n");
$smtp->datasend("Subject: EZML Daily Report - $monthNames[$month] $date $year\n");
$smtp->datasend("\n========================================================\n");
#
# Body
#-------------------------------------------------------------------------------
$smtp->datasend("\n\n Report File: $report_file1\n");
$smtp->datasend("\n -----------------\n");
open FH,"$report_file1" || smtp->datasend("Warnning : Can't open $report_file1\n");
$smtp->datasend("$_") while (<FH>);
close (FH);
#------------------------------------------------------------------------------
$smtp->datasend("\n\n Report File: $report_file2\n");
$smtp->datasend("\n -----------------\n");
open FH,"$report_file2" || smtp->datasend("Warnning : Can't open $report_file2\n");
$smtp->datasend("$_") while (<FH>);
close (FH);
#------------------------------------------------------------------------------
$smtp->dataend;
$smtp->quit;
print "Sending ok!\n";
