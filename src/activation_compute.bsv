/*
Details:
The top module where all the computing submodules are instantiated and controlled
as per required.

Notes on Exceptions:
Invalid flag is never set as cfloat_1_5_2 implementation doesnt support NaN encodings.
Denormal flag is set when there is an operation with operand being a denormal number.
Overflow flag is set when the number was not able to be represented in the 2 mantissa bits of the format.
Underflow flag is set when the computed number is less than smallest possible number (i.e) 0.25 x 2^-bias.
Author: Mouna Krishna
email: mounakrishna27121999@gmail.com
*/

package activation_compute;
  import Vector :: *;
  import GetPut :: *;
  import types :: *;
  import FIFO :: *;
  import FIFOF :: *;
  import common :: *;
  import SpecialFIFOs :: *;
  import sigmoid_lut :: *;
  import selu_lut :: *;

  interface Ifc_activation_compute;
    method Action ma_input(Cfloat_1_5_2 inp, Int#(6) bias, Operation op);
    method ActionValue#(Maybe#(OutputStageMeta)) mav_output;
  endinterface: Ifc_activation_compute

  module mkactivation_compute(Ifc_activation_compute);
    /*doc: fifo: FIFO to store the inputs*/
    FIFOF#(PreprocessStageMeta) ff_input <- mkFIFOF();

    /*doc: fifo: The preprocessed outputs are taken from previous stage and are passed onto compute
           stage via these FIFOs.*/
    FIFOF#(ComputeStageMeta) ff_compute <- mkFIFOF();

    /*doc: fifo: The computed output from previous stage is taken and post processed.
                 Post processed in the sense, normalisation, exception flag calculation*/
    FIFOF#(PostprocessStageMeta) ff_post_process <- mkFIFOF();

    /*doc: fifo: FIFO to store the outputs*/
    FIFOF#(OutputStageMeta) ff_output <- mkFIFOF();

    Ifc_sigmoid_lut_region_1 sigmoid_lut1 <- mksigmoid_lut_region_1;
    Ifc_sigmoid_lut_region_2 sigmoid_lut2 <- mksigmoid_lut_region_2;

    Ifc_selu_lut_region_1 selu_lut1 <- mkselu_lut_region_1;
    //Ifc_selu_lut_region_2 selu_lut2 <- mkselu_lut_region_2;
    //Ifc_selu_lut_region_3 selu_lut3 <- mkselu_lut_region_3;

    function Tuple2#(Bit#(4), Int#(8)) fn_compute_sigmoid(ComputeStageMeta data);
      Bit#(4) final_mantissa;
      Int#(8) final_exp;
      if (data.sign == 1) begin
        if (data.act_exp >= -63 && data.act_exp <= -4) begin
          final_mantissa = 4'b1000;
          final_exp = -1;
        end
        else if (data.act_exp >= -3 && data.act_exp <= 5) begin
          Bit#(4) exp_index = truncate(pack(data.act_exp + 3));
          let lut_output = sigmoid_lut1.mv_sig_output(exp_index, data.act_mantissa[1:0]);
          final_mantissa = {1'b1, tpl_2(lut_output), 1'b0};
          final_exp = signExtend(tpl_1(lut_output));
        end
        else begin // exp >= 6
          final_mantissa = 0;
          final_exp = 0;
        end
      end
      else begin
        if (data.act_exp >= -63 && data.act_exp <= -3) begin
          final_mantissa = 0;
          final_exp = -1;
        end
        else if (data.act_exp >= -2 && data.act_exp <= 1) begin
          Bit#(2) exp_index = truncate(pack(data.act_exp + 2));
          let lut_output = sigmoid_lut2.mv_sig_output(exp_index, data.act_mantissa[1:0]);
          final_mantissa = {1'b1, tpl_2(lut_output), 1'b0};
          final_exp = signExtend(tpl_1(lut_output));
        end
        else begin
          final_mantissa = {1'b1, 2'b11, 1'b0};
          final_exp = 0;
        end
      end

      return tuple2(final_mantissa, final_exp);
    endfunction

    /*doc: rule: Get the inputs, preprocess the input and fire the corresponding rules
           for the required operation.  
           Preprocessing the input involves finding the actual final exponent after subtracting with bias
           and then deducing the actual mantissa with hidden bit.*/
    rule rl_preprocessing(ff_input.notEmpty);
      ff_input.deq;
      let lv_input= ff_input.first.inp;
      let lv_bias = ff_input.first.bias;
      Flags lv_flags = unpack(0);

      if(isDenormal(lv_input.exp, lv_input.mantissa))
        lv_flags.denormal = True;

      Int#(8) actual_inp_exp = unpack(zeroExtend(lv_input.exp)) - zeroExtend(lv_bias);
      Bit#(3) actual_mantissa = {hiddenBit(lv_input.exp), lv_input.mantissa};

      ff_compute.enq(ComputeStageMeta { sign: ff_input.first.inp.sign,
                                        act_exp: actual_inp_exp,
                                        act_mantissa: actual_mantissa,
                                        bias: lv_bias,
                                        op: ff_input.first.op,
                                        flags: lv_flags
                                      });
    endrule: rl_preprocessing

    rule rl_compute_sigmoid(ff_compute.first.op == Sigmoid && ff_compute.notEmpty);
      ff_compute.deq;
      let data = ff_compute.first;

      PostprocessStageMeta lv_output;
      let bias = data.bias;
      lv_output.bias = data.bias;
      lv_output.flags = data.flags;
      lv_output.final_sign = 0;

      let tmp_output = fn_compute_sigmoid(data);
      lv_output.final_mantissa = tpl_1(tmp_output);
      lv_output.final_exp = tpl_2(tmp_output);

      ff_post_process.enq(lv_output);
    endrule

    rule rl_compute_tanh(ff_compute.first.op == Tanh && ff_compute.notEmpty);
      ff_compute.deq;
      let data = ff_compute.first;

      PostprocessStageMeta lv_output;
      let bias = data.bias;
      lv_output.bias = data.bias;
      lv_output.flags = data.flags;
      lv_output.final_sign = data.sign;
      
      lv_output.final_mantissa = {data.act_mantissa, 1'b0};
      lv_output.final_exp = signExtend(data.act_exp);

      ff_post_process.enq(lv_output);
    endrule

    rule rl_compute_seluh(ff_compute.first.op == SeLu && ff_compute.notEmpty);
      ff_compute.deq;
      let data = ff_compute.first;

      PostprocessStageMeta lv_output;
      let bias = data.bias;
      lv_output.bias = data.bias;
      lv_output.flags = data.flags;
      lv_output.final_sign = data.sign;

      if (data.sign == 1) begin
        if (data.act_exp >= -63 && data.act_exp <= -55) begin
          lv_output.final_mantissa = 0;
          lv_output.final_exp = 0;
        end
        else if (data.act_exp >= -54 && data.act_exp <= 0) begin
          Bit#(6) exp_index = truncate(pack(data.act_exp + 54));
          let lut_output = selu_lut1.mv_selu_output(exp_index, data.act_mantissa[1:0]);
          lv_output.final_mantissa = {1'b1, tpl_2(lut_output), 1'b0};
          lv_output.final_exp = signExtend(tpl_1(lut_output));
        end
        else begin
          lv_output.final_mantissa = {1'b0, 2'b11, 1'b0};
          lv_output.final_exp = 0;
        end
      end
      else begin
        lv_output.final_mantissa = {data.act_mantissa, 1'b0};
        lv_output.final_exp = signExtend(data.act_exp);
      end

      ff_post_process.enq(lv_output);
    endrule

    /*doc: rule: The rule computes the LeakyReLu of the input data.
           Formula:
           output = max(0.01*x, x) 
           which is basically, if x is negative then return 0.01 times of input else just return input
           0.01 is represented as +1.01*2^-7 in float representation. With only three bits multiplication, 
           the output is calculated as a LUT to save on after multiplication normalisation logic.
           If the input is a denormal number, the output is always zero as the exponent exceeds bias value.
           Else value is taken from LUT if input is less than zero. The output in this case can still exceed 
           the range. The post processing stage will take care of the normalisation.
    */
    rule rl_compute_LeakyReLu(ff_compute.first.op == LeakyReLu && ff_compute.notEmpty);
      ff_compute.deq;
      let data = ff_compute.first;

      PostprocessStageMeta lv_output;
      let bias = data.bias;
      lv_output.bias = data.bias;
      lv_output.flags = data.flags;
      lv_output.final_sign = data.sign;

      if (data.sign == 0) begin
        lv_output.final_exp = data.act_exp;
        lv_output.final_mantissa = {data.act_mantissa, 1'b0};
      end
      else begin
        if (data.act_mantissa[2] == 0) begin
          lv_output.final_exp = signExtend(-bias);
          lv_output.final_mantissa = 0;
          lv_output.flags.underflow = True;
        end
        else begin
          case(data.act_mantissa[1:0])
            2'b00: begin
              lv_output.final_exp = data.act_exp - 7;
              lv_output.final_mantissa = 4'b1010;
            end
            2'b01: begin
              lv_output.final_exp = data.act_exp - 7;
              lv_output.final_mantissa = 4'b1100;
              lv_output.flags.overflow = True;
            end
            2'b10: begin
              lv_output.final_exp = data.act_exp - 7;
              lv_output.final_mantissa = 4'b1111; //Round to nearest
              lv_output.flags.overflow = True;
            end
            2'b11: begin
              //$display("Hello");
              lv_output.final_exp = data.act_exp - 6;
              lv_output.final_mantissa = 4'b1000;
              lv_output.flags.overflow = True;
            end
            default: begin
              lv_output.final_exp = 0;
              lv_output.final_mantissa = 4'b0000;
            end
          endcase
        end
      end

      ff_post_process.enq(lv_output);
    endrule: rl_compute_LeakyReLu

    rule rl_postprocessing(ff_post_process.notEmpty);
      ff_post_process.deq;
      let computed_output = ff_post_process.first;
      Cfloat_1_5_2 final_output;
      let bias = computed_output.bias;

      if (computed_output.final_exp < signExtend(-bias-3)) begin
        computed_output.flags.underflow = True;
        final_output = Cfloat_1_5_2 { sign : computed_output.final_sign,
                                      exp: 0,
                                      mantissa: 2'b00
                                    };
      end
      else if (computed_output.final_exp >= signExtend(-bias-3)
              && computed_output.final_exp < signExtend(-bias)) begin
        //Integer number_of_shift = unpack(pack(-bias)) + unpack(pack(-compute_output.final_exp));
        $display(computed_output.final_mantissa);
        $display(signExtend(-bias) - computed_output.final_exp);
        Bit#(4) calc_final_mantissa = computed_output.final_mantissa >> (signExtend(-bias) - computed_output.final_exp);
        $display(calc_final_mantissa);
        if (calc_final_mantissa[0] == 1)
          calc_final_mantissa = calc_final_mantissa + 1;
        final_output = Cfloat_1_5_2 { sign : computed_output.final_sign,
                                      exp: 0,
                                      mantissa: calc_final_mantissa[2:1]
                                    };
      end
      else if (computed_output.final_exp > signExtend(-bias + 31)) begin
        final_output = Cfloat_1_5_2 { sign : computed_output.final_sign,
                                      exp: 31, 
                                      mantissa: 2'b11
                                    };
      end
      else begin
        $display("before: %d", computed_output.final_mantissa);
        if (computed_output.final_mantissa[0] == 1)
          computed_output.final_mantissa = computed_output.final_mantissa + 1;
        if (computed_output.final_mantissa == 0) begin
          computed_output.final_mantissa = 4'b1000;
          computed_output.final_exp = computed_output.final_exp + 1;
        end
        $display("after: %d", computed_output.final_mantissa);
        final_output = Cfloat_1_5_2 { sign : computed_output.final_sign,
                                      exp: pack(truncate(signExtend(bias) + computed_output.final_exp)), 
                                      mantissa: computed_output.final_mantissa[2:1]
                                    };
      end

      ff_output.enq(OutputStageMeta { out : final_output,
                                      flags : computed_output.flags
                                    });
    endrule

    method Action ma_input(Cfloat_1_5_2 inp, Int#(6) bias,Operation op);
      ff_input.enq(PreprocessStageMeta { inp: inp,
                                         bias: bias,
                                         op: op
                                       });
    endmethod

    method ActionValue#(Maybe#(OutputStageMeta)) mav_output;
      ff_output.deq;
      return tagged Valid ff_output.first;
    endmethod
  endmodule
endpackage
