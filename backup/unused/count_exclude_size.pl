#!/usr/bin/perl
#-----------------------------------------
#Writer : Mico Cheng
#Version: 2005050301
#Host   : mk2-1 ,mk2-2
#Use for: Daily backup
#------------------------------------------
$base_dir = "/home/webmail/mico/backup_prog";
$backup_dir = "/webmail/m2kwork/backup";
$exclude_list_file = "$base_dir/exclude.list";

print "\nFinding exclude list,please wait......\n";

system "/usr/bin/find /webmail/m2kwork/usr/ -type f|egrep '\@'|egrep -v '\@.address|\@acl.dat'>$exclude_list_file";
system "/usr/bin/find /webmail/log/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/httpd/logs/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/mqueue/log/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/metadata/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/alarm/log/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/report/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/sophos/log/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/metadata.combine/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/m2kwork/usr/trash/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/m2kwork/log/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/httpd/cgi-bin/*.core -type f>>$exclude_list_file";
system "/usr/bin/find //webmail/m2kwork/backup/system-backup* -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/m2kwork/log_archive1/ -type f>>$exclude_list_file";
system "/usr/bin/find /webmail/m2kwork/log_archive2/ -type f>>$exclude_list_file";

open EXCLUDE_LIST,($exclude_list_file) or die "can't open $exclude_list_file\n";

while (<EXCLUDE_LIST>) {
    chomp;
    $_ = `ls -l $_`;
    ##-rw-r--r--  1 webmail  webmail  109 Apr 27 11:46 /webmail/m2kwork/tmp/Attach.dat
    ($exclude_size) = $_ =~ /webmail\s+(\d+)\s+\w{3}/;
    $total_exclude_size+=$exclude_size;
}

$total_exclude_ksize = $total_exclude_size/1048576;

print "Total exclude size is $total_exclude_ksize MBytes\n";
