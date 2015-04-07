set ns [new Simulator]
set val(x) 500
set val(y) 500
set val(chan) Channel/WirelessChannel    ;# channel type
set val(prop) Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             2                      ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)              500   			   ;# X dimension of topography
set val(y)              400   			   ;# Y dimension of topography  
set val(stop)		10.0			   ;# time of simulation end

# set up topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)

#Nam File Creation  nam - network animator
set namfile [open sample1.nam w]

#Tracing all the events and cofiguration
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#Trace File creation
set tracefile [open sample1.tr w]

#Tracing all the events and cofiguration
$ns trace-all $tracefile

# general operational descriptor- storing the hop details in the network
create-god $val(nn)

# configure the nodes
        $ns node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace ON

set node1 [$ns node]

$node1 color black

$node1 set X_ 200
$node1 set Y_ 100
$node1 set Z_ 0

set node2 [$ns node]
$node2 color black

$node2 set X_ 200
$node2 set Y_ 300
$node2 set Z_ 0

$ns at 0.1 "$node1 color blue"
$ns at 0.1 "$node1 label Node1"
$ns at 0.1 "$node2 label Node2"


$ns initial_node_pos $node1 30
$ns initial_node_pos $node2 30

set tcp0 [new Agent/TCP]
$ns attach-agent $node1 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set tcpsink0 [new Agent/TCPSink]
$ns attach-agent $node2 $tcpsink0
$ns connect $tcp0 $tcpsink0

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"

$ns at 1.0 "$ftp0 start"
$ns at 10.01 "$ns halt"


proc stop {} {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile
	#executing nam file
	exec nam sample1.nam &
}



#Starting scheduler
$ns run
