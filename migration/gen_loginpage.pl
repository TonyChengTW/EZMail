#!/usr/bin/perl

open(REF, "<$ARGV[0]") || print "\nUsage: ./gen_loginpage.pl <list>\n\n";
while($info = <REF>) {
        chomp($info);
        print "$info\n";
	($e1,$e2,$e3,$e4) = split(/\,/, $info);
       	print "$e1,$e2,$e3,$e4\n";
	system("/webmail/tools/nph-login_gen $e1 $e2 $e3 $e4 1");
}
close(REF);
exit;
