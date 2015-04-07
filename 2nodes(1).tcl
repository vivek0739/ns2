#PROGRAM-4

#CBR over UDP
set ns [new Simulator]
set tracefile [open out.tr w]
$ns trace-all $tracefile
set nf [open out.nam w]
$ns namtrace-all $nf

proc finish { } {
global ns tracefile nf
$ns flush-trace 
close $nf
close $tracefile
exec nam out.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0

$ns at 0.5 "$cbr0 start"
$ns at 3.0 "$cbr0 stop"
$ns at 5.0 "finish"

$ns run

