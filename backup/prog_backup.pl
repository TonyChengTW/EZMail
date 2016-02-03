#!/usr/bin/perl
#--------------------------------------------------
#Writer : Mico Cheng
#Version: 2005060801
#Use for: backup /webmail prog
#Hosts: Mail 2000 System
#---------------------------------------------------
chomp($localtime = `date +%Y%m%d`);

system "/usr/local/bin/tar --exclude-from /home/webmail/mico/backup/exclude_for_prog_backup.list --ignore-failed-read -zcvf /webmail/m2kwork/backup/ezml-prog-$localtime.tar.gz /webmail >/dev/null 2>&1";

system "/usr/bin/scp /webmail/m2kwork/backup/ezml-prog-$localtime.tar.gz backup_acc\@210.200.211.17:/backup/ezml";
system "rm -f /webmail/m2kwork/backup/*";
