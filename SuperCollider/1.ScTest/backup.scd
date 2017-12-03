~oled.screen(5,"Test Patch Loaded");

~voices = Dictionary.new;
~cutoff = 5000.0;
~oled.screen(1,format("Cutoff %",~cutoff.asInteger));

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

~knobs.addDependant(~knobfunc);


SynthDef(\testSynth,
    {
        arg freq=440,gate=1,cutoff=440;
        var sig,env,amp=0.3;
        sig = Saw.ar(freq);
        env = EnvGen.ar(Env.adsr(),gate,doneAction:2);
        sig = sig * env * amp;
        sig = LPF.ar(sig,cutoff.clip(10,24000));
        Out.ar(0,sig!2);
    }
).add;


~keyfunc = { 
    arg func, msg, key, vel; 
    if(vel>0 , { 
        if(~voices[key]!=nil,{~voices[key].set(\gate,0);});
        ~voices[key] = Synth.new(\testSynth,[
            \freq, (key+59).midicps,
            \cutoff, ~cutoff,
        ]
    );
    } , {
        if(~voices[key]!=nil,{~voices[key].set(\gate,0);});
        ~voices[key] = nil;
    };)
};

~keys.addDependant(~keyfunc);

