(
SynthDef(\piano2, { |out=0, freq=440, gate=1|
	var oscs = [Saw.ar([freq, freq+3, freq+7], 0, 1),
			   Pulse.ar([freq, freq+3, freq+7]),
			   LFNoise0.ar(freq/2, 0.55),
			   MdaPiano.ar(freq, gate, release: 0.59, stereo: 0.3, sustain: 0.25)
			];
			
	var mix = Mix.ar(oscs);
	
	
	Out.ar(out, mix * EnvGate.new(gate: gate));
}).store;
)

(
TempoClock.default.tempo = 2;
Ppar([
	x = Pbind(
		\instrument, \piano2,
		\degree,
			Pseq([ 
				0, 7, -5, 7, 0, 5, -7, 5,  -2, 5, -7, 5,  -2,  3, -9,  3,
				0, 7, -5, 7, 0, 5, -7, 5,  -2, 5, -7, 5,  -2, -3, -4, -5 ], inf),
		\dur, 0.5, 
		\octave, 3, 
		\root, 3,
		\vel, Prand([Pseq([100, 30, 50, 10]), Pseq([100, 30, 10, 10, 5, 10, 20, 30])], inf),
		\legato, 0.95
	),
	y = Pbind(
		\instrument, \piano2,
		\degree,
			Pseq([ \, 0, -1, 0, 2, 0, \, \, \, 0, -2, \, \, -2, -4, \, \ ], inf),
		\dur, 0.5, 
		\octave, 6, 
		\root, 3,
		\vel, Pbrown(50, 100, inf)
	)
], inf).play
)
