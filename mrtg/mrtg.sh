#!/bin/sh
/home/webmail/mico/mrtg/catch.pl > /home/webmail/mico/mrtg/mrtg.log
/usr/local/bin/ncftpput -E -u mrtg -p 123qwe 210.201.31.28 html/mico/m2k-1.aptg.net /home/webmail/mico/mrtg/mrtg.log >/dev/null 2>&1
