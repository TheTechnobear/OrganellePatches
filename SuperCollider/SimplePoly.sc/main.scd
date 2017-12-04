
// initialise
~voices = Dictionary.new;
~cutoff = 5000.0;
~oled.screen(1,format("Cutoff %",~cutoff.asInteger));
~oled.screen(5,"Test Patch Loaded");

// create knob callback
~knobfunc = {
	arg func, msg, knob, value;
	if(knob==0, {
		~cutoff = value.linexp(0,1,50,20000);
		~oled.screen(1,format("Cutoff % Hz",~cutoff.asInteger));
		~voices.values.do({
			arg  v;
			v.set(\cutoff,~cutoff);
		}
		);
	});
};
// register knob callback
~knobs.addDependant(~knobfunc);


// create notes callback
~notesfunc = {
	arg func, msg, note, vel;
	if(vel>0 , {
		if(~voices[note]!=nil,{~voices[note].set(\gate,0);});
		~voices[note] = Synth.new(\testSynth,[
			\freq, (note).midicps,
			\cutoff, ~cutoff,
			\amp, (vel / 3.0) .clip(0,1.0)
		]
		);
    	~led.value(1);
	} , {
		if(~voices[note]!=nil,{~voices[note].set(\gate,0);});
		~voices[note] = nil;
		~led.value(0);
	};)
};
// register key callback
~notes.addDependant(~notesfunc);

//other callbacks
//~encoder_turn
//~encoder_button
//~footswitch

SynthDef(\testSynth, {
		arg freq=440,gate=1,cutoff=440,amp=0.3;
		var sig,env;
		sig = Saw.ar(freq);
		env = EnvGen.ar(Env.adsr(),gate,doneAction:2);
		sig = sig * env * amp;
		sig = LPF.ar(sig,cutoff.clip(10,24000));
		Out.ar(~outL,sig!2);
	}
).add;

