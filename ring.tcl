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
for { set i 0 } { $i < 7} { incr i} {
	set n($i) [$ns node]
}
for { set i 0 } {$i<7} {incr i} {
	$ns duplex-link $n($i) $n([expr ($i+1)%7]) 1Mb 10ms DropTail
}
$ns at 5.0 "finish"
$ns run