(
	SynthDef(\guitar, {|out, gate=1, freq=440|
		var oscs, env, input, output, sig, deltimes, delrd;
		oscs = [
			Saw.ar([freq, freq+3, freq+7], 0.7),
			Pulse.ar([freq, freq+3, freq+7]),
			LFNoise0.ar(freq/2, 0.55)
		];
		
		input = FreeVerb.ar(Mix.ar(oscs), 0, 0.2, 0.2);
		
	     delrd = LocalIn.ar(4);
	     output = input + delrd[[0,1]];

		// Cross-fertilise the four delay lines with each other:
	    sig = [output[0]+output[1]+delrd[2]+delrd[3],
	           output[0]-output[1]+delrd[2]-delrd[3],
	           output[0]+output[1]-delrd[2]-delrd[3],
	           output[0]-output[1]-delrd[2]+delrd[3]];
	    
	    
	    // Attenutate the delayed signals so they decay:
	    sig = sig * [0.54, 0.37, 0.333, 0.3];
         deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
         LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));

			
		env = EnvGen.kr(Env.perc(0.05, 0.5, 1.0), gate, doneAction: 2);
				
		Out.ar(out, output * env);
	}).send(s);
)


Synth(\guitar);

(

var q, notes, timings;

q = 1/4;

notes Ê = [ 0, 3, 5, 3, 5, 1, 5, 3, 3, 3, 1,   0];
timings = [ 1, 1, 1, q, 1, 1, 1, q, q, q, q, 0.5];Ê

Pbind(
  \instrument, \guitar,
  \legato,     0.2,
  \degree,     Pseq(notes, inf),
  \dur,        Pseq(timings, inf),
  \root,		 4,
  \octave,     3,
  \out,        0
).play;

);
	