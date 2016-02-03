#!/usr/bin/perl

# domain name => $d
# corpation name => $c
# quota => $q
# expire time => $e
# /webmail/tools/AddDomain $d ezmail.aptg.net $d '' '' '' 0 $q $c '' '' '' $e '' '' 0

if($#ARGV != 0) {
	print "\nUsage: $0 <domain list>\n\n";
	print "format of list:\n";
	print "[domain name],[corpation name],[quota],[expire time]\n\n";
	exit;
}

my ($d, $c, $q, $e);
my $TOTAL = $OK = 0;
my $log = "$0.log";
$log =~ s/\.pl//;
$cookie = "ezmail.aptg.net";
$lst = $ARGV[0];

if (!-f "$lst") {
	print "[ERROR] $lst doesn't exist!\n";
	exit;
}

open(IN, "<$lst");
open(LOG, ">$log");
while(<IN>) {
	my $ERR = "";
	$TOTAL++;
	chomp;
	$_ =~ s/ //g;
	($d, $c, $q, $e) = split(/,/, $_);
	$q *= 1024;
        #########   Modify by Miko Cheng  2005/05/23  #################
        $_ = $d;
        s/\./_/g;
        $f = '/'.$_.'.html';
	#$str = "$d $cookie $d '' '' '' 0 $q '$c' '' '' '' $e '' '' 0";
	$str = "$d $cookie '$f' '' '' '' 0 $q '$c' '' '' '' $e '' '' 0";
        ##############################################################
	$cmd = "/webmail/tools/AddDomain $str 2>&1 1>/dev/null";
	$ERR = `$cmd`;
	if ($ERR eq "") {
		$OK++;
		$ddir = `/webmail/tools/domaindir $d`;
		unlink("$ddir/admin") || die "cannot delete $ddir/admin: $!";
		print LOG "[SUCCESS] $d\n";
	}
	else { print LOG "[FAIL] $d: $ERR" }
}
print LOG "=" x 40 . "\n";
print LOG "Import: $TOTAL\n";
print LOG "Success: $OK\n\n";
close(LOG);
close(IN);
