/*
instrument proto
has a start, stop, free
has a master amplitude
has an aux patch
has a defaults array
has a .synth attribute
*/


~instrument = Proto({|bus=0,auxOut=0|
  ~className = "Instrument";
  ~synthName = "default";
  //a patch for master volume or routing to effects
  ~auxPatch = Synth("aux-patch",[\in,bus,\out,auxOut]);
  //shorthand for amp param
  ~setAmp = {|a=1|~auxPatch.set(\amp,a)};
  //output bus
  ~setBus = {|b|~synth.set(\bus,b);~auxPatch.set(\in,b)};
  //aux out channel
  ~setAuxOut = {|a|~auxPatch.set(\out,a)};

  ~start = {
  //step through defaults
    //init synth
    ~synth = Synth(~synthName);
    ~defaults.keys.do({|key|
      ~synth.setn(key,~defaults.at(key));
    });
    ~synth.set(\gate,1);
    ~auxPatch.set(\amp,0);
  };
  ~stop = {~synth.set(\gate,0)};
  ~free = {~synth.free};
  ~defaults = ();
});

~instrumentCluster = Proto({
  ~instruments = [];
  ~set = {|params|
    ~instruments.collect({|i|
      params.keys.do({|key|
        i.setn(key,params.at(key))
      });
    });
  }
});


