set ns [new Simulator]
$ns color 1 red
$ns color 2 green
$ns color 3 blue
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
for { set i 0 } { $i < 5} { incr i} {
	set n($i) [$ns node]
}
for { set i 1 } { $i < 5} { incr i} {
	$ns duplex-link $n(0) $n($i) 1Mb 10ms DropTail
}
set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.005


set udp2 [new Agent/UDP]
$ns attach-agent $n(2) $udp2 
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005

set udp3 [new Agent/UDP]
$ns attach-agent $n(3) $udp3 
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set packetSize_ 500
$cbr3 set interval_ 0.005

set udp4 [new Agent/UDP]
$ns attach-agent $n(4) $udp4 
set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp4
$cbr4 set packetSize_ 500
$cbr4 set interval_ 0.005

$udp1 set class_ 1
$udp2 set class_ 2
$udp3 set class_ 3


set null0 [new Agent/Null]
$ns attach-agent $n(0) $null0

$ns connect $udp1 $null0
$ns connect $udp2 $null0
$ns connect $udp3 $null0
$ns connect $udp4 $null0

$ns at 0.1 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"

$ns at 0.1 "$cbr2 start"
$ns at 4.5 "$cbr2 stop"

$ns at 0.1 "$cbr3 start"
$ns at 4.5 "$cbr3 stop"

$ns at 0.1 "$cbr4 start"
$ns at 4.5 "$cbr4 stop"

$ns at 5.0 "finish"

$ns run