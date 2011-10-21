(
SynthDef(\help_mdapiano, { |out=0, freq=440, gate=1|
	var son = MdaPiano.ar(freq, gate, release: 0.59, stereo: 0.3, sustain: 0.25);
	DetectSilence.ar(son, 0.01, doneAction:2);
	Out.ar(out, son * 1);
}).store;
)(
TempoClock.default.tempo = 2;
Ppar([
	x = Pbind(
		\instrument, \help_mdapiano,
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
		\instrument, \help_mdapiano,
		\degree,
			Pseq([ \, 0, -1, 0, 2, 0, \, \, \, 0, -2, \, \, -2, -4, \, \ ], inf),
		\dur, 0.5, 
		\octave, 6, 
		\root, 3,
		\vel, Pbrown(50, 100, inf)
	)
], inf).play
)

