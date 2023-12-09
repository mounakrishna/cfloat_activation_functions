package sigmoid_lut;
  import Vector :: *;
  import FIFOF :: *;
  import GetPut :: *;
  import types :: *;

  interface Ifc_sigmoid_lut_region_1;
    method Tuple2#(Bit#(5), Bit#(2)) mv_sig_output(Bit#(4) exp, Bit#(2) man);
  endinterface

  module mksigmoid_lut_region_1(Ifc_sigmoid_lut_region_1);
    Reg#(Bit#(2)) rg_man_output[36];
    rg_man_output[0] = readOnlyReg(0); //IN = - 00 -3, OUT = + 00 -1
    rg_man_output[1] = readOnlyReg(3); //IN = - 01 -3, OUT = + 11 -2

    Reg#(Int#(5)) rg_exp_output[36];
    rg_exp_output[0] = readOnlyReg(-1);
    rg_exp_output[1] = readOnlyReg(-2);

    method Tuple2#(Bit#(5), Bit#(2)) mv_sig_output(Bit#(4) exp, Bit#(2) man);
      Bit#(6) index = {man, exp};
      return tuple2(rg_man_output[index], rg_exp_output[index]);
    endmethod
  endmodule
endpackage
