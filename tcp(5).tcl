set ns [new Simulator]

set f [open out.tr w]
$ns trace-all $f
set nf [open out.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n1 1Mb 10ms DropTail
$ns duplex-link $n0 $n2 1Mb 10ms DropTail

set tcp0 [new Agent/TCP]
$tcp0 set window_ 16
$tcp0 set fid_ 1
$ns attach-agent $n0 $tcp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set PacketSize_ 5000
$cbr0 set interval_ .005
$cbr0 attach-agent $tcp0

set sink0 [new Agent/TCP]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0

proc finish { } {
		global ns nf f
		$ns flush-trace
		close $f
		close $nf
		exec nam out.nam
		exit
		}

$ns at 0.5 "$cbr0 start"
$ns at 3.0 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
