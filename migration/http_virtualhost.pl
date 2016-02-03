#!/usr/bin/perl
#--------------------------------
# Writer : Mico Cheng
# Version: 2005050901
# Use for: Generate http
# Host :   m2k-1,m2k-2
#---------------------------------
if ($#ARGV ne 0) {
    print "\n./http_virtualhost.pl <Domain list>\n";
    exit 0;
}
    
$base_dir = '/home/webmail/mico/migration';
$domain_list = shift;

open DN,"$domain_list" or die "$!\n";
open FH,">$base_dir/http_virtualhost.list" or die "$!\n";

#<VirtualHost 203.79.224.1>
#    ServerAdmin m2k@m2k.strongniche.com.tw
#    DocumentRoot /webmail/httpd/data/m2k.strongniche.com.tw/
#    ServerName webmail.m2k.strongniche.com.tw
#    ErrorLog logs/m2k.strongniche.com.tw-err_log
#    CustomLog logs/m2k.strongniche.com.tw-access_log common
#</VirtualHost>

while (<DN>) {
    chomp;
    ($domain) = (split /,/, $_)[0];
    ($adm) = (split /\./, $domain)[0];
    $_ = $domain;
    s/\./_/g;
    $domain_dir = $_;

    print FH "\n<VirtualHost 203.79.224.1>\n";
    print FH "    ServerAdmin $adm\@$domain\n";
    print FH "    DocumentRoot /webmail/httpd/data/$domain_dir/\n";
    print FH "    ServerName webmail.$domain\n";
    print FH "    ErrorLog logs/$domain-err_log\n";
    print FH "    CustomLog logs/$domain-access_log common\n";
    print FH "</VirtualHost>\n";
}

close(DN);
close(FH);
