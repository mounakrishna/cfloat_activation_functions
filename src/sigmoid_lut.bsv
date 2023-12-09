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
    rg_man_output[2] = readOnlyReg(3);
    rg_man_output[3] = readOnlyReg(3);
    rg_man_output[4] = readOnlyReg(3);
    rg_man_output[5] = readOnlyReg(3);
    rg_man_output[6] = readOnlyReg(3);
    rg_man_output[7] = readOnlyReg(2);
    rg_man_output[8] = readOnlyReg(2);
    rg_man_output[9] = readOnlyReg(2);
    rg_man_output[10] = readOnlyReg(1);
    rg_man_output[11] = readOnlyReg(1);
    rg_man_output[12] = readOnlyReg(0);
    rg_man_output[13] = readOnlyReg(3);
    rg_man_output[14] = readOnlyReg(2);
    rg_man_output[15] = readOnlyReg(1);
    rg_man_output[16] = readOnlyReg(0);
    rg_man_output[17] = readOnlyReg(1);
    rg_man_output[18] = readOnlyReg(2);
    rg_man_output[19] = readOnlyReg(0);
    rg_man_output[20] = readOnlyReg(1);
    rg_man_output[21] = readOnlyReg(3);
    rg_man_output[22] = readOnlyReg(1);
    rg_man_output[23] = readOnlyReg(3);
    rg_man_output[24] = readOnlyReg(1);
    rg_man_output[25] = readOnlyReg(2);
    rg_man_output[26] = readOnlyReg(2);
    rg_man_output[27] = readOnlyReg(3);
    rg_man_output[28] = readOnlyReg(0);
    rg_man_output[29] = readOnlyReg(0);
    rg_man_output[30] = readOnlyReg(1);
    rg_man_output[31] = readOnlyReg(2);
    rg_man_output[32] = readOnlyReg(3);
    rg_man_output[33] = readOnlyReg(1);
    rg_man_output[34] = readOnlyReg(0);
    rg_man_output[35] = readOnlyReg(0);

    Reg#(Int#(5)) rg_exp_output[36];
    rg_exp_output[0] = readOnlyReg(-1);
    rg_exp_output[1] = readOnlyReg(-2);
    rg_exp_output[2] = readOnlyReg(-2);
    rg_exp_output[3] = readOnlyReg(-2);
    rg_exp_output[4] = readOnlyReg(-2);
    rg_exp_output[5] = readOnlyReg(-2);
    rg_exp_output[6] = readOnlyReg(-2);
    rg_exp_output[7] = readOnlyReg(-2);
    rg_exp_output[8] = readOnlyReg(-2);
    rg_exp_output[9] = readOnlyReg(-2);
    rg_exp_output[10] = readOnlyReg(-2);
    rg_exp_output[11] = readOnlyReg(-2);
    rg_exp_output[12] = readOnlyReg(-1);
    rg_exp_output[13] = readOnlyReg(-2);
    rg_exp_output[14] = readOnlyReg(-2);
    rg_exp_output[15] = readOnlyReg(-2);
    rg_exp_output[16] = readOnlyReg(-3);
    rg_exp_output[17] = readOnlyReg(-4);
    rg_exp_output[18] = readOnlyReg(-5);
    rg_exp_output[19] = readOnlyReg(-5);
    rg_exp_output[20] = readOnlyReg(-6);
    rg_exp_output[21] = readOnlyReg(-8);
    rg_exp_output[22] = readOnlyReg(-9);
    rg_exp_output[23] = readOnlyReg(-11);
    rg_exp_output[24] = readOnlyReg(-12);
    rg_exp_output[25] = readOnlyReg(-15);
    rg_exp_output[26] = readOnlyReg(-18);
    rg_exp_output[27] = readOnlyReg(-21);
    rg_exp_output[28] = readOnlyReg(-23);
    rg_exp_output[29] = readOnlyReg(-29);
    rg_exp_output[30] = readOnlyReg(-35);
    rg_exp_output[31] = readOnlyReg(-41);
    rg_exp_output[32] = readOnlyReg(-47);
    rg_exp_output[33] = readOnlyReg(-58);
    rg_exp_output[34] = readOnlyReg(0);
    rg_exp_output[35] = readOnlyReg(0);

    method Tuple2#(Int#(7), Bit#(2)) mv_sig_output(Bit#(4) exp, Bit#(2) man);
      Bit#(6) index = {man, exp};
      return tuple2(rg_man_output[index], rg_exp_output[index]);
    endmethod
  endmodule

  interface Ifc_sigmoid_lut_region_2;
    method Tuple2#(Int#(7), Bit#(2)) mv_sig_output(Bit#(2) exp, Bit#(2) man);
  endinterface

  module mksigmoid_lut_region_2(Ifc_sigmoid_lut_region_2);
    Reg#(Bit#(2)) rg_man_output[16];
    rg_man_output[0] = readOnlyReg(0); 
    rg_man_output[1] = readOnlyReg(1); 
    rg_man_output[2] = readOnlyReg(1);
    rg_man_output[3] = readOnlyReg(1);
    rg_man_output[4] = readOnlyReg(1);
    rg_man_output[5] = readOnlyReg(1);
    rg_man_output[6] = readOnlyReg(1);
    rg_man_output[7] = readOnlyReg(2);
    rg_man_output[8] = readOnlyReg(0);
    rg_man_output[9] = readOnlyReg(0);
    rg_man_output[10] = readOnlyReg(1);
    rg_man_output[11] = readOnlyReg(1);
    rg_man_output[12] = readOnlyReg(3);
    rg_man_output[13] = readOnlyReg(3);
    rg_man_output[14] = readOnlyReg(3);
    rg_man_output[15] = readOnlyReg(3);

    Reg#(Int#(5)) rg_exp_output[16];
    rg_exp_output[0] = readOnlyReg(-1);
    rg_exp_output[1] = readOnlyReg(-1);
    rg_exp_output[2] = readOnlyReg(-1);
    rg_exp_output[3] = readOnlyReg(-1);
    rg_exp_output[4] = readOnlyReg(-1);
    rg_exp_output[5] = readOnlyReg(-1);
    rg_exp_output[6] = readOnlyReg(-1);
    rg_exp_output[7] = readOnlyReg(-1);
    rg_exp_output[8] = readOnlyReg(-1);
    rg_exp_output[9] = readOnlyReg(-1);
    rg_exp_output[10] = readOnlyReg(-1);
    rg_exp_output[11] = readOnlyReg(-1);
    rg_exp_output[12] = readOnlyReg(-1);
    rg_exp_output[13] = readOnlyReg(-1);
    rg_exp_output[14] = readOnlyReg(0);
    rg_exp_output[15] = readOnlyReg(0);

    method Tuple2#(Int#(7), Bit#(2)) mv_sig_output(Bit#(2) exp, Bit#(2) man);
      Bit#(4) index = {man, exp};
      return tuple2(rg_man_output[index], rg_exp_output[index]);
    endmethod
  endmodule
endpackage
