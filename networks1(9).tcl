set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf
set var [open trfile.tr w]
$ns trace-all $var
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
$ns duplex-link $n0 $n2 100Mb 5ms DropTail
$ns duplex-link $n1 $n2 100Mb 5ms DropTail
$ns duplex-link $n3 $n2 54Mb 10ms DropTail
$ns duplex-link $n4 $n2 54Mb 10ms DropTail
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n3 $n2 orient left
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set ftp0 [new Application/FTP]
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.005
$ftp0 attach-agent $tcp0
$udp0 set class_ 1
$tcp0 set class_ 2
$ns color 1 blue
$ns color 2 red
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns connect $udp0 $null0
$ns connect $tcp0 $sink0
$ns at 0.5 "$cbr0 start"
$ns at 0.5 "$ftp0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 4.5 "$ftp0 stop"
$ns at 5.0 "finish"
$ns run

