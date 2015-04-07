set ns [new Simulator]
set tracefile [open out.tr w]
$ns trace-all $tracefile
set nf [open out.nam w]
$ns namtrace-all $nf
set n0 [$ns node]
set n1 [$ns node]
$ns simplex-link $n0 $n1 1Mb 10ms DropTail
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set tcpsink0 [new Agent/TCPSink]
$ns attach-agent $n1 $tcpsink0
$ns connect $tcp0 $tcpsink0
proc finish { } {
global ns tracefile nf
$ns flush-trace 
close $nf
close $tracefile
exec nam out.nam &
exit 0
}
$ns at 1.0 "$ftp0 start"
$ns at 2.5 "$ftp0 stop"
$ns at 3.0 "finish"
$ns run

