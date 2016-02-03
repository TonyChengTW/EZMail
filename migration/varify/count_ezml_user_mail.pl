#!/usr/local/bin/perl
#--------------------------------------
#Writer : Mico Cheng
#Version: 2005051801
#Use for: Count mails in every EZML account
#Host   : EZML(203.79.224.60)
#---------------------------------------
$user_count = 0;
$mbox_count = 0;
$total_mbox_count = 0;
$base_dir = "/m2k_old_mail/";
@user_mbox = `ls -l $base_dir|awk '{print \$9}'|grep '_'`;
#@user_mbox = qw /a1038_neostones/;
foreach (@user_mbox) {
    $user_count++;
    chomp;
    $user = $_;
    #$user_file = "$base_dir"."$_";
    print "\$user_file = $user_file\n";
    #$_ = `cat $user_file|sed -e '\/^\\000\/d'|grep "^From "|wc -l`;
    $_ = `cat $user_file|grep "^From "|wc -l`;
    ($mbox_count) = ($_ =~ /^\s+(\d+)$/);
    print "$user ==> $mbox_count\n";
    $total_mbox_count += $mbox_count;
}
print "\n\nTotal mail count=$total_mbox_count\n";
