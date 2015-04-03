set ns [new Simulator]
set tf [open out.tr w]
$ns trace-all $tf
set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam out.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n2 1MB 10ms DropTail
$ns duplex-link $n1 $n2 1MB 10ms DropTail
$ns duplex-link $n3 $n2 1MB 10ms DropTail
$ns duplex-link $n4 $n2 1MB 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0
#$udp0 set class_ blue

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns connect $tcp0 $sink0
#$tcp0 set class_ red

set cbr0 [new Application/Traffic/CBR]
$cbr0 set paketSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set ftp0 [new Application/FTP]
$ftp0 set paketSize_ 500
$ftp0 set interval_ 0.005
$ftp0 attach-agent $tcp0

$ns at 0.1 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

$ns at 0.1 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"

$ns at 5.0 "finish"

$ns run