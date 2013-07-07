//methods for multi-server load balancing
~loadBalancer = Proto({
  ~step = 0;
  ~overflowThreshold = 100;
  ~createServers = {|n|
  };
  ~servers = Server.all;
  //return a server in step sequence
  ~roundRobin = {
    ~servers.wrapAt(~step);
  };
  //return a random server
  ~random = {
    ~servers.choose;
  };
  //when one server reaches CPU threshold, route to next server
  ~overflow = {
    (~servers[0].peakCPU > ~overflowThreshold).if ({
      ~servers = ~servers.rotate(1);
    });
    ~servers[0];
  };
  //just return server # x
  ~manual = {|x|
    ~servers.wrapAt(x);
  };
});
