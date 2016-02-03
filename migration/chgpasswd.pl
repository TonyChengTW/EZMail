#!/usr/bin/perl
system "find /webmail/m2kwork/usr/ -name .passwd > find.tmp";
open FH,"find.tmp" or die "$!\n";
while (<FH>) {
    chomp;
    system "cp /home/webmail/mico/migration/.passwd $_";
}
system "rm find.tmp";
