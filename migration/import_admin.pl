#!/usr/bin/perl

# email => $e
# passwd => $p

if($#ARGV != 0) {
	print "\nUsage: $0 <admin list>\n\n";
	print "format of list:\n";
	print "[email],[passwd]\n\n";
	exit;
}

my ($e, $p);
my $TOTAL = $OK = 0;
my $log = "$0.log";
$log =~ s/\.pl//;
$lst = $ARGV[0];

if (!-f "$lst") {
        print "[ERROR] $lst doesn't exist!\n";
        exit;
}

open(CONF, "</webmail/etc/mail2000.conf");
while(<CONF>) {
	$l1q = $_ if (/^LEVEL/);
}
close(CONF);
$l1q = (split(/,/, $l1q))[6];

open(IN, "<$lst");
open(LOG, ">$log");
while(<IN>) {
	my $ERR = $ERR2 = "";
	$TOTAL++;
	chomp;
	$_ =~ s/ //g;
	($e, $p) = split(/,/, $_);
	$str = "$e,$p,hint,-$l1q,1";
	$cmd = "/webmail/tools/importuser -ai $str 2>/dev/null";
	$ERR = `$cmd`;
	if ($ERR eq "") {
		$cmd2 = "/webmail/tools/add_adm DEFAULT $e 4 2>/dev/null";
		$ERR2 = `$cmd2`;
		if ($ERR2 =~ /added./) {
			$OK++;
			print LOG "[SUCCESS] $e\n";
		}
		else { print LOG "[FAIL] $e: $ERR2" }
	}
	else { print LOG "[FAIL] $e: $ERR" }

}
print LOG "=" x 40 . "\n";
print LOG "Import: $TOTAL\n";
print LOG "Success: $OK\n\n";
close(LOG);
close(IN);
