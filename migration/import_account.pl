#!/usr/bin/perl

# account => $acc
# domain => $domain
# encrypted passwd => $passwd
# name => $name
# quota => $quota, import + level 1 = real quota
# forward => $forward
# forward list => $tmp
# department => $dep

if($#ARGV != 0) {
	print "\nUsage: $0 <account list>\n\n";
	print "format of list:\n";
	print "[account],[domain],[encrypted passwd],[name],[quotaMB],[forward?],[f-email1];[f-email2];..,[dept]\n\n";
	exit;
}

my ($acc, $domain, $passwd, $name, $quota, $forward, $tmp, $dep);
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
	my $ERR = "";
	$TOTAL++;
	chomp;
	($acc, $domain, $passwd, $name, $quota, $forward, $tmp, $dep) = split(/,/, $_);
	$acc =~ s/ //;
	$domain =~ s/ //;
	$passwd =~ s/ //;
	$quota =~ s/ //;
	$forward =~ s/ //;
	$tmp =~ s/ //;
	$quota = $quota * 1024 - $l1q;
	$str = "$acc\@$domain,'$passwd',hint,$quota,1,,'$name'" . ","x24 . "'$dep'";
	$cmd = "/webmail/tools/importuser -asi $str 2>/dev/null";
	$ERR = `$cmd`;
	if ($ERR eq "") {
		$OK++;
		print LOG "[SUCCESS] $acc\@$domain\n";
	}
	else { print LOG "[FAIL] $acc\@$domain: $ERR" }

	# generate forward list
	if ($tmp ne "") {
		my $file = `/webmail/tools/userhome $acc\@$domain` . "/.forward";
		open(OU, ">$file");
		@emails = split(/;/, $tmp);
		foreach $email (@emails) {
			print OU "$email\n";
		}
		print OU "$acc\@$domain\n";
		close(OU);
		rename("$file", "$file.old") if ($forward != 0);
	}
}
print LOG "=" x 40 . "\n";
print LOG "Import: $TOTAL\n";
print LOG "Success: $OK\n\n";
close(LOG);
close(IN);
