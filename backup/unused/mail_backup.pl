#!/usr/bin/perl
#--------------------------------------------------
#Writer : Mico Cheng
#Version: 2005060801
#Use for: backup mails
#Hosts: Mail 2000 System
#---------------------------------------------------
chomp($localtime = `date +%Y%m%d`);

system "/usr/local/bin/tar --ignore-failed-read -zcvf /webmail/m2kwork/backup/ezml-usr-$localtime.tar.gz /webmail/m2kwork/usr/ 2>/home/webmail/mico/report/mail_backup.$localtime";

system "/usr/bin/scp /webmail/m2kwork/backup/ezml-usr-$localtime.tar.gz backup_acc\@210.200.211.17:/backup/ezml";
