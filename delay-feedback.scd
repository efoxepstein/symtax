{       
    var input, output, delrd, sig, deltimes;
 
	input = Mix.ar([
		Pulse.ar(440, 0, 1),
		Saw.ar(100, 0, 0.5),
		SinOsc.ar(440, 0, 0.5)
	]);
	
	// Read our 4-channel delayed signals back from the feedback loop
    delrd = LocalIn.ar(4);
 
    // This will be our eventual output, which will also be recirculated
    output = input + delrd[[0,1]];
 
    // Cross-fertilise the four delay lines with each other:
    sig = [output[0]+output[1]+delrd[2]+delrd[3],
           output[0]-output[1]+delrd[2]-delrd[3],
           output[0]+output[1]-delrd[2]-delrd[3],
           output[0]-output[1]-delrd[2]+delrd[3]];
    
    
    // Attenutate the delayed signals so they decay:
    sig = sig * [0.4, 0.37, 0.333, 0.3];
 
    // Here we give delay times in milliseconds, convert to seconds,
    // then compensate with ControlDur for the one-block delay 
    // which is always introduced when using the LocalIn/Out fdbk loop
    deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
 
    // Apply the delays and send the signals into the feedback loop
    LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
 
 
    output
}.scope