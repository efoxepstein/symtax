(
	s = Server.local;
	SynthDef(\help_SPE1, { arg i_out=0, freq;
		var out;
		out = RLPF.ar(
			LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: 2 )),
			LFNoise1.kr(1, 36, 110).midicps,
			0.1
		);
		Out.ar( i_out, out );
	}).send(s);
)

(
	var stream, dur;
	dur = 1/8;
	stream = Routine.new({{ 24.yield; 31.yield; 36.yield; 43.yield; 48.yield; 55.yield; }.loop});

	Routine({
	      loop({
			Synth(\help_SPE1, [ \freq, stream.next.midicps ] );
			dur.wait; // synonym for yield, used by .play to schedule next occurence
		})
	}).play
)
