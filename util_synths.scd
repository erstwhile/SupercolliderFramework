Server.all.collect({|s|
  SynthDef("aux-patch",{|in,out,amp=1|
    Out.ar(out,InFeedback.ar(in,2)*amp);
  }).send(s);
});
