package compute_tanh;
  import Vector :: *;
  import FIFOF :: *;
  import GetPut :: *;
  import types :: *;

  interface Ifc_compute_tanh;
    method Action send(cfloat_1_5_2 in, Bit#(6) bias);
    method cfloat_1_5_2 receive();
  endinterface

  module mkcompute_tanh;
    Wire#(cfloat_1_5_2) in <- mkDWire(0);
  endmodule
endpackage
