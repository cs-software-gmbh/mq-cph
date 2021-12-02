use strict;
use warnings;
use File::Path;
use Sys::Hostname;

my ($clientServer, $numChannels, $numQueues, $qmc_name, $qms_name, $qmc_host, $qms_host, $qmc_port, $qms_port, $batchSize) = @ARGV;

if($numQueues < $numChannels){
	print STDERR "Number of queues must be equal or greater than the number of channels";
	exit  8;
}

if($clientServer eq "CLIENT"){
	if($numChannels == 1) {
	    print "DEFINE QLOCAL($qms_name.TX) USAGE(XMITQ) MAXDEPTH(15000)  REPLACE\n";
		print "DEFINE CHANNEL(OUT.$qmc_name) CHLTYPE(SDR) CONNAME('$qms_host($qms_port)') XMITQ($qms_name.TX) TRPTYPE(TCP) MCATYPE(PROCESS) BATCHSZ($batchSize) SSLCIPH('')\n";
		print "START CHANNEL(OUT.$qmc_name)\n";
		print "DEFINE CHANNEL(IN.$qmc_name) CHLTYPE(RCVR) TRPTYPE(TCP) SSLCAUTH(OPTIONAL) BATCHSZ($batchSize) SSLCIPH('')\n";

		for (my $i=1; $i<=$numQueues; $i++){
    		print "DEFINE QREMOTE(REQUEST$i) RNAME(REQUEST$i) RQMNAME($qms_name) XMITQ($qms_name.TX) REPLACE\n";
    		print "DEFINE QLOCAL(REPLY$i) REPLACE\n";
		}
	} else {
		for (my $i=1; $i<=$numChannels; $i++){
			print "DEFINE QLOCAL($qms_name.TX$i) USAGE(XMITQ) MAXDEPTH(15000)  REPLACE\n";
			print "DEFINE CHANNEL(OUT.$qmc_name.$i) CHLTYPE(SDR) CONNAME('$qms_host($qms_port)') XMITQ($qms_name.TX$i) TRPTYPE(TCP) MCATYPE(PROCESS) BATCHSZ($batchSize) SSLCIPH('')\n";
			print "START CHANNEL(OUT.$qmc_name.$i)\n";
			print "DEFINE CHANNEL(IN.$qmc_name.$i) CHLTYPE(RCVR) TRPTYPE(TCP) SSLCAUTH(OPTIONAL) BATCHSZ($batchSize) SSLCIPH('')\n";
			print "DEFINE QREMOTE($qmc_name.QM$i) RNAME('') RQMNAME($qmc_name)\n";
		}

		my $currentChannel=1;
		for (my $i=1; $i<=$numQueues; $i++){
			print "DEFINE QREMOTE($qmc_name.REPLY$i) RNAME(REPLY$i) RQMNAME($qmc_name.QM$currentChannel)\n";
    		print "DEFINE QREMOTE(REQUEST$i) RNAME(REQUEST$i) RQMNAME($qms_name) XMITQ($qms_name.TX$currentChannel) REPLACE\n";
    		print "DEFINE QLOCAL(REPLY$i) REPLACE\n";
			$currentChannel = ($currentChannel % $numChannels) +1;
		}
	}

} else {
	if($numChannels == 1) {
       	print "DEFINE CHANNEL(OUT.$qmc_name) CHLTYPE(RCVR) TRPTYPE(TCP) SSLCAUTH(OPTIONAL) BATCHSZ($batchSize) SSLCIPH('')\n";
       	print "DEFINE QLOCAL($qmc_name) USAGE(XMITQ) MAXDEPTH(15000) REPLACE\n";
       	print "DEFINE CHANNEL(IN.$qmc_name) CHLTYPE(SDR) CONNAME('$qmc_host($qmc_port)') XMITQ($qmc_name) TRPTYPE(TCP) MCATYPE(PROCESS) BATCHSZ($batchSize) SSLCIPH('')\n";
	   	print "START CHANNEL(IN.$qmc_name)\n";

	   	for (my $i=1; $i<=$numQueues; $i++){
 	   		print "DEFINE QLOCAL(REQUEST$i) maxdepth(999999999) replace\n";
 	   		print "DEFINE QLOCAL(REPLY$i) maxdepth(999999999) replace\n";
		}
	} else {
		for (my $i=1; $i<=$numChannels; $i++){
    		print "DEFINE CHANNEL(OUT.$qmc_name.$i) CHLTYPE(RCVR) TRPTYPE(TCP) SSLCAUTH(OPTIONAL) BATCHSZ($batchSize) SSLCIPH('')\n";
       		print "DEFINE QLOCAL($qmc_name.QM$i) USAGE(XMITQ) MAXDEPTH(15000) REPLACE\n";
       		print "DEFINE CHANNEL(IN.$qmc_name.$i) CHLTYPE(SDR) CONNAME('$qmc_host($qmc_port)') XMITQ($qmc_name.QM$i) TRPTYPE(TCP) MCATYPE(PROCESS) BATCHSZ($batchSize) SSLCIPH('')\n";
	   		print "START CHANNEL(IN.$qmc_name.$i)\n";
		}

		for (my $i=1; $i<=$numQueues; $i++){
 	   		print "DEFINE QLOCAL(REQUEST$i) maxdepth(999999999) replace\n";
 	   		print "DEFINE QLOCAL(REPLY$i) maxdepth(999999999) replace\n";
		}
	}
}
