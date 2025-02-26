mol new step3_input.psf
for { set i 1 } { $i <= 100 } { incr i } { 
mol addfile step5_$i.dcd waitfor all

}
