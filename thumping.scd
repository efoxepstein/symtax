(
SynthDef(\muted, {|out=0,freq=440,gate=1,amp=1|	
	var sin1 = SinOsc.ar(Pulse.ar(1)*24);
	var sin2 = SinOsc.ar(90 + (LFNoise0.ar(8)*90));
	var moog = MoogFF.ar(
		Saw.ar(LFNoise0.ar(4,333,666)),
		LFNoise0.ar(8)*XLine.ar(1,39,99,99,0,2));
		
	(sin1 + sin2 + moog)!2/3
}).store
)


Synth(\muted);

(
SynthDef(\muted2, {
//	var sin1 = SinOsc.ar(Pulse.ar(1)*24);
//	var sin2 = SinOsc.ar(90+(LFNoise0.ar(8)*90));
//	var moog = MoogFF.ar(SinOsc.ar(LFNoise0.ar(4,333,666)),LFNoise0.ar(8)*XLine.ar(1,39,99,99,0,2));
	Out.ar(0, SinOsc.ar());
}).send(s);
)

Synth(\muted2);

play{x=SinOsc;y=LFNoise0;a=y.ar(8);(x.ar(Pulse.ar(1)*24)+x.ar(90+(a*90))+MoogFF.ar(SinOsc.ar(y.ar(4,333,666)),a*XLine.ar(1,39,99,99,0,2)))!2/3}





Ptpar(({|i|[i*8,Pbind(\scale,[0,2,4,7,9],\degree,Pseq(32.fib.fold(0,10),4)+(2*i+i)-10,\dur,1+2**i%2/6)]}!4).flat).play // #supercollider

/*eclecticity -- REALLY FUCKING LOUD */ Ndef(\x, { SinOsc.ar(BrownNoise.ar(30!2, 200), Ndef(\x).ar * LFNoise1.kr(1!2,1,1)) }).play;

play{VarSaw.ar((Hasher.ar(Latch.ar(SinOsc.ar((1..4)!2),Impulse.ar([5/2,5])))*300+300).round(60),0,LFNoise2.ar(2,1/3,1/2))/5}//#supercollider

{13.do{|i|k="SuperCollider"[i].ascii;20.do{|u|{MoogFF.ar(Saw.ar((k/4).midicps)*EnvGen.ar(Env.perc),u+k*9,k/30)}.play;(k*0.001).wait}}}.fork

play{a=Duty.kr(0.1,0,Dseq(fib(32).wrap(20,55).midicps,inf));HPF.ar(LeakDC.ar(Splay.ar(LFCub.ar([-1,a,a/3,-2])))*9).clip2/9};//#supercollider

f={|t|Pbind(\note,Pseq([-1,1,6,8,9,1,-1,8,6,1,9,8]+5,319),\dur,t)};Ptpar([0,f.(1/6),12,f.(0.1672)],1).play//#supercollider reich RT @earslap

play{f=LocalIn.ar(2).tanh;k=Latch.kr(f[0].abs,Impulse.kr(1/4));LocalOut.ar(f+CombC.ar(Blip.ar([4,6],100*k+50,0.9),1,k*0.3,50*f));f}//44.1kHz


