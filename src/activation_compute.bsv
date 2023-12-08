/*
Details:
The top module where all the computing submodules are instantiated and controlled
as per required.

Author: Mouna Krishna
email: mounakrishna27121999@gmail.com
*/

package activation_compute;
  import Vector :: *;
  import GetPut :: *;
  import types :: *;
  import FIFO :: *;

  interface Ifc_activation_compute;
    interface Put#(cfloat_1_5_2, Int#(6)) put_input;
    interface Get#(Maybe#(cfloat_1_5_2)) get_output;
  endinterface: Ifc_activation_compute

  module mkactivation_compute;
    /*doc: fifo: FIFO to store the inputs*/
    FIFOF#(PreprocessStageMeta) ff_input <- mkPipelineFIFOF();

    /*doc: fifo: The preprocessed outputs are taken from previous stage and are passed onto compute
           stage via these FIFOs.*/
    FIFOF#(ComputeStageMeta) ff_start_compute <- mkPipelineFIFOF();

    /*doc: fifo: The computed output from previous stage is taken and post processed.
                 Post processed in the sense, normalisation, exception flag calculation*/
    FIFOF#(PostprocessStageMeta) ff_post_process <- mkPipelineFIFOF();

    /*doc: fifo: FIFO to store the outputs*/
    FIFOF#(OutputStageMeta) ff_output <- mkPipelineFIFOF();

    /*doc: rule: Get the inputs, preprocess the input and fire the corresponding rules
           for the required operation.  
           Preprocessing the input involves finding the actual final exponent after subtracting with bias
           and then deducing the actual mantissa with hidden bit.*/
    rule rl_preprocessing;
      ff_input.deq;
      let lv_input= ff_input.first.inp;
      let lv_bias = ff_input.first.bias;

      Int#(8) actual_inp_exp = zeroExtend(lv_input.exp) - zeroExtend(bias);
      Bit#(3) actual_mantissa = {hiddenBit(actual_inp_exp), lv_input.mantissa};

      ff_compute.enq(ComputeStageMeta { sign: ff_input.first.inp.sign
                                        act_exp: actual_inp_exp,
                                        act_mantissa: actual_mantissa,
                                        bias: lv_bias,
                                        op: ff_input.first.op
                                      });
    endrule: rl_preprocessing

    /*doc: rule: The rule computes the LeakyReLu of the input data.
           Formula:
           output = max(0.01*x, x) 
           which is basically, if x is negative then return 0.01 times of input else just return input
           0.01 is represented as +1.01*2^-7 in float representation. With only three bits multiplication, 
           the output is calculated as a LUT to save on after multiplication normalisation logic.
           If the input is a denormal number, the output is always zero as the exponent exceeds bias value.
           Else value is taken from LUT if input is less than zero. The output in this case can still exceed 
           the range. The post processing stage will take care of the normailsation.
    */
    rule rl_compute_LeakyReLu(ff_compute.first.op == LeakyReLu && ff_compute.notEmpty);
      ff_compute.deq;
      let data = ff_compute.first;

      OutputStageMeta lv_output;
      lv_output.final_sign = data.sign;

      if (data.sign == 0) begin
        lv_output.final_exp = data.exp;
        lv_output.final_mantissa = data.act_mantissa;
      end
      else begin
        if (data.act_mantissa[2] == 0) begin
          lv_output.final_exp = -bias;
          lv_output.final_mantissa = 0;
        end
        else begin
          case(data.act_mantissa[1:0])
            2'b00: begin
              lv_output.final_exp = data.act_exp - 7;
              lv_output.final_mantissa = 3'b101;
            end
            2'b01: begin
              lv_output.final_exp = data.act_exp - 7;
              lv_output.final_mantissa = 3'b110;
            end
            2'b10: begin
              lv_output.final_exp = data.act_exp - 6;
              lv_output.final_mantissa = 3'b100; //Round to nearest
            end
            2'b11: begin
              lv_output.final_exp = data.act_exp - 6;
              lv_output.final_mantissa = 3'b100;
            end
            default: begin
              lv_output.final_exp = 0;
              lv_output.final_mantissa = 3'b000;
            end
          endcase
        end
      end

      ff_post_process.enq(lv_output);
    endrule: rl_compute_LeakyReLu

    rule rl_postprocessing;
    endrule

    interface put_input = interface Put
      method Action put(cfloat_1_5_2 in, Int#(6) bias, Operation operation);
        ff_input.enq(PreprocessStageMeta { inp: in,
                                           bias: bias,
                                           op: operation
                                         });
      endmethod
    endinterface;

    interface get_output = interface Get
      method ActionValue#(Maybe#(cfloat_1_5_2)) get;
        ff_output.deq;
        return ff_output.first;
      endmethod
    endinterface;
  endmodule
endpackage
