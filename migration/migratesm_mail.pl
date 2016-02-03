#!/usr/bin/perl
# Only for APOL

if ($#ARGV != 1) {
	print "Usage: ./migratesm_mail.pl <virtualuser file> <spool directory>\n";
	print "Remember add a backslash \"\/\" at the end.\n";
	print "eg: ./migratesm_mail.pl /etc/mail/virtualuser /var/spool/\n\n";
	exit;
}

my ($ref, $path) = @ARGV;
my $TOTAL = $OK = 0;
my $log = "$0.log";
$log =~ s/\.pl//;
$| = 1;

if (!-d $path) {
	print "[ERROR] $path doesn't exist!\n";
	exit;
}

if (substr($path, length($path) - 1, 1) ne "\/") {
	print "[ERROR] missing \"\/\" at the end!\n";
	exit;
}

open(REF, "<$ref");
open(LOG, ">$log");
while(<REF>) {
	$TOTAL++;
	chomp;
	($user, $file) = split(/\t/);
	$userpath = `/webmail/tools/userhome $user`;
	$mailpath = $userpath . "/@";

	if (!-f "$userpath/.passwd") {
		print "[ERROR] $user doesn't exist in mail!\n";
		next;
	}

	$ID = 0;
	$First = 1;
	$lastline = "";

	open(IN, "<$path$file");
	while($line = <IN>) {
		$From = 0;

		if ($First == 1) {
			$fname = "$mailpath/$ID";
			open(OU, ">$fname");
			$ID++;
			$First = 0;
			$From = 1;
		}

		if (($line =~ /^From /) && ($lastline eq "\n")) {
			close(OU);
			$fname = "$mailpath/$ID";
			open(OU, ">$fname");
			$ID++;
			$From = 1;
		}

		print OU "$line" if ($From == 0);

		$lastline = $line;
	}

	close(IN);
	close(OU);

	$fname = "$mailpath/.DIR";

	system("/webmail/tools/builddir -m $mailpath");
	print LOG "[$ID] mail(s) $user\n";
}
print LOG "\n";
close(LOG);
close(REF);
