//Archive the entire Composition to disk, in its currently running state

~loaderGui = Proto({
  //set the base path for the composition
  ~path = Platform.userHomeDir;
  //gui panel
  ~panel = nil;
  ~initGui = {
    ~panel = GUI.window.new("Values",Rect(128,64,420,420));
    ~panel.view.decorator = FlowLayout(~panel.view.bounds);
    ~panel.view.background = Color(0.7,0.7,0.7);
    ~iB =  TextField(~panel, Rect(150, 10, 300, 20));
    ~iF =  TextField(~panel, Rect(150, 10, 300, 20));
    ~iT =  TextField(~panel, Rect(150, 10, 300, 20));
    ~iI =  TextField(~panel, Rect(150, 10, 300, 20));
    ~iFils =  TextField(~panel, Rect(150, 10, 300, 20));
    ~iIll =  TextField(~panel, Rect(150, 10, 300, 20));
    ~iX = TextField(~panel, Rect(150, 10, 300, 20));
    ~iFac =TextField(~panel, Rect(150, 10, 300, 20));
    ~iCPU = TextField(~panel, Rect(150, 10, 300, 20));
    ~panel.front;
  };

  //create a temp dir, write the archive text files
  ~archive = {|f,completeAction=({"done".postln;})|
    var path,a;
    path = ~path++f.asString;
    //create the temp dir
    Routine {
      Pipe.new("mkdir "++path,"w");
      0.1.wait;

      Pipe.new("chmod -R 777 "++path,"w");
      0.1.wait;

      a=File(path++"/_keys.scd","w");
      a.write(currentEnvironment.keys.asCompileString.asString);
      a.close;
      0.1.wait;
      {a=File(path++"/_currentEnvironment.scd","w");
        a.write(currentEnvironment.asCompileString.asString);
        a.close;}.defer;
      0.1.wait;

      currentEnvironment.keys.do({|x|
        (currentEnvironment.at(x).isFunction).if({
          currentEnvironment.at(x).writeArchive(path++"/"++x.asString++".scd");
          0.1.wait;
        })
      });
      completeAction.();
    }.play;
  };

  ~restore = {|f|
    var path = ~path ++f, keys,file;
    keys = Object.readArchive(path++"/_keys.scd");
    keys.postln;
    keys.asArray.do({|key|
      file = path++"/"++key++".scd";
      (File.exists(file)).if({currentEnvironment.put(key.asSymbol,Object.readArchive(file));
      });
    })
  };

  ~refresh = {|f|
    ~archive.(f,~restore.(f));
  };

  ~restoreFull = {|f|
    var path = ~path ++f, keys,file;
    Object.readArchive(path++"/_currentEnvironment.scd");
  };
});
/*
todo
gui for save / restore (with filesystem browser?)
Super-functions to interpolate 2 functions
linear average
oscillating average (with period)
the returned function should be connected to the original...one changes and the other changes too
a = blend({|x|x.nthPrime},{|x|2**x},{|f|f})
where f as the blend frac is the logDistance of some int
*/