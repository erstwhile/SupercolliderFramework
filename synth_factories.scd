~synthFactoryBus = {|name, func,l=(Server.internal)|  	SynthDef(name, {|gate =0, atk=18, rel=10,amp=1,bus=0|  	var out;
  out = SynthDef.wrap(func);
  Out.ar(bus,Mix.ar(out *amp) * EnvGen.ar(Env.asr(atk, 1, rel, 'linear'),gate, doneAction:2))  	}).send(l)  };

~synthFactory = {|name, func,l=(Server.internal),pan =({[-1,1]})|  	SynthDef(name, {|gate =0, atk=18, rel=10,amp=1,bus=0,doneAction=2|  	var out;
  out = SynthDef.wrap(func);
  Out.ar(bus,Mix.ar(Pan2.ar(out *amp,pan.value)) * EnvGen.ar(Env.asr(atk, 1, rel, 'linear'),gate, doneAction:doneAction))  	}).load(l)  };

~synthFactoryPerc = {|name, func,pan =({[-1,1]}),l=(Server.internal),doneAction=2|  	SynthDef(name, {|gate =0, atk=18, sus=1, rel=10,amp=1,bus=0|  	var out;  	out = SynthDef.wrap(func);  		Out.ar(bus,Mix.ar(Pan2.ar(out * amp,pan.value)) * EnvGen.ar(Env.perc(atk,rel,1,sus),gate, doneAction:doneAction))
}).send(l)  };

