#!/usr/bin/perl
#---------------------------------------------------------------
# Writer : Mico Cheng
# Version: 20050512
# Use for: count mail 2000 each account's mail number
# Host: m2k-1 , m2k-2
#----------------------------------------------------------------
$|=1;
$count = 0;
$user_mail_count = 0;
$total_mail_count = 0;
$virtusertable_file = '/m2k_old_mail/mico/virtusertable';
$base_dir = '/webmail/m2kwork/usr/';

open VIRTABLE,"$virtusertable_file" or die "$!\n";
while (<VIRTABLE>) {
    $count++;
    chomp;
    ($account,$mbox) = (split /\t/, $_)[0,1];
    $user_dir = `/webmail/tools/userhome $account`;
    $user_dir = $user_dir.'\/@';
    $_ = `/usr/bin/find $user_dir -type f|wc -l`;
    ($user_mail_count) = ($_ =~ /^\s+(\d+)$/);
    $user_mail_count = $user_mail_count-2;  # exclude .DIR & welcome
    $total_mail_count += $user_mail_count;
    #print "$mbox ==> $user_mail_count\t$account\n";
    print "$mbox ==> $user_mail_count\n";
}
    print "\n\nTotal mail count=$total_mail_count\n";
