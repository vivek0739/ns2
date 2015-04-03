set ns [new Simulator]

#define different color

$ns color 1 Red

$ns color 2 blue


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

set nf [open o.nam w]
$ns namtrace-all $nf

$ns duplex-link $n4 $n0 2mb 10ms DropTail
$ns duplex-link $n0 $n2 2mb 10ms DropTail
$ns duplex-link $n1 $n2 2mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7mb 10ms DropTail

proc finish {} {
        global ns nf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Execute NAM on the trace file
        exec nam o.nam &
        exit 0
}
$ns queue-limit $n2 $n3 10

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0

$udp0  set fid_ 1
set cbr [new Application/Traffic/CBR]

$cbr attach-agent $udp0

$cbr set types_ CBR
$cbr set packetSize_ 1000
$cbr set rate_ 1Mb
$cbr set random false

$ns at 0.1 "$cbr start"
$ns at 4.5 "$cbr stop"
#$ns at 5.0 "finish"

set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n3 $null1

$ns connect $udp1 $null1
$udp1  set fid_ 2
set cbr1 [new Application/Traffic/CBR]

$cbr1 attach-agent $udp1
$cbr1 set types_ CBR
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 1Mb
$cbr1 set random false

$ns at 0.1 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"
$ns at 5.0 "finish"


$ns run
