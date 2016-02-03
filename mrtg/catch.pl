#!/usr/bin/perl
#-----------------------
# Version : 2005051301
# Writer  : Mico Cheng
# Use for : Accounting MRTG Record
# Host    : Mail 2000 
# Filename: queuenum.pl
#-----------------------
#  Host Info
print "host m2k-1.aptg.net\n";
print "ip 203.79.224.1\n";

#  Accounting CPU

$uptime_1 = `uptime|cut -d',' -f1`;
$uptime_2 = `uptime|cut -d',' -f5`; $uptime_2=$uptime_2*100;
$uptime_3 = `uptime|cut -d',' -f6`; $uptime_3=$uptime_3*100;
print "uptime $uptime_1";
print "cpu $uptime_2 $uptime_3\n";

#  Accounting Disk Usage

$diskuseage = 'df -k |';
open (DSK,$diskuseage)||die "can executing df program!!";
while(<DSK>)
{
  chomp;
  if (/(\S+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+%)\s+(\/\S*)/)
  {
    $diskusage = int $3/1000;
    $diskall = int $2/1000;
    print "disk_$6 $diskusage $diskall $5\n";
  }
}

#  Accounting Process
chomp($mailerd = `ps ax|grep mailerd|grep -v 'grep'|wc -l`);
chomp($smtpd = `ps ax|grep smtpd|grep -v 'grep'|wc -l`);
chomp($pop3d = `ps ax|grep pop3d|grep -v 'grep'|wc -l`);
chomp($imap4d = `ps ax|grep imap4d|grep -v 'grep'|wc -l`);
chomp($httpd = `ps ax|grep httpd|grep -v 'grep'|wc -l`);

($mailerd) = ($mailerd =~ /^\s+(\d+)/);
($smtpd) = ($smtpd =~ /^\s+(\d+)/);
($pop3d) = ($pop3d =~ /^\s+(\d+)/);
($imap4d) = ($imap4d =~ /^\s+(\d+)/);
($httpd) = ($httpd =~ /^\s+(\d+)/);

print "mailerd_smtpd $mailerd $smtpd\n";
print "pop3d_imap4d $pop3d $imap4d\n";
print "httpd $httpd\n";

#  Accounting Mail Queue Number

$active_mailq=0;$deferred_mailq=0;$incoming_mailq=0;
$queue_base_dir = "/webmail/mqueue";
@queue_main_array = qw/ res run buggy spam retry wait /;

foreach $queue_main_dir (@queue_main_array) {
    $queue_whole_dir = $queue_base_dir."/".$queue_main_dir;
    $_ = `find $queue_whole_dir -type f|wc -l`;
    ($queuenum) = ($_ =~ /^\s+(\d+)/);
    push(@queuenum,$queuenum);
    #print "$queue_main_dir"."_queue = $queuenum\n";
}
$res_queue = shift(@queuenum);
$run_queue = shift(@queuenum);
$buggy_queue = shift(@queuenum);
$spam_queue = shift(@queuenum);
$retry_queue = shift(@queuenum);
$wait_queue = shift(@queuenum);

$_ = `find /webmail/mqueue_q/init -type f|wc -l`;
($init_queue) = ($_ =~ /^\s+(\d+)/);
print "res_run_queue $res_queue $run_queue\n";
print "buggy_spam_queue $buggy_queue $spam_queue\n";
print "retry_wait_queue $retry_queue $wait_queue\n";
print "init_queue $init_queue 0\n";
