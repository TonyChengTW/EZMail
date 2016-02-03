#!/usr/bin/perl
#--------------------------------------------------
#Writer : Mico Cheng
#Version: 2005060801
#Use for: backup mico's prog
#Hosts: Mail 2000 System
#---------------------------------------------------
chomp($localtime = `date +%Y%m%d`);

system "/usr/local/bin/tar --ignore-failed-read -zcvf /webmail/m2kwork/backup/mico-tool-$localtime.tar.gz /home/webmail/mico >/dev/null 2>&1";

system "/usr/bin/scp /webmail/m2kwork/backup/mico-tool-$localtime.tar.gz backup_acc\@210.200.211.17:/backup/ezml";
