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
    interface Put#(cfloat_1_5_2, Bit#(6)) put_input;
    interface Get#(Maybe#(cfloat_1_5_2)) get_output;
  endinterface: Ifc_activation_compute

  module mkactivation_compute;
    /*doc: fifo: FIFO to store the inputs*/
    FIFOF#(Tuple2#(cfloat_1_5_2, Bit#(6))) ff_input <- mkFIFOF();
    FIFOF#(Operation) ff_input_operation <- mkFIFOF();

    /*doc: fifo: FIFO to store the outputs*/
    FIFOF#(Maybe#(cfloat_1_5_2)) ff_output <- mkFIFOF();

    /*doc: rule: Get the inputs and start the required operation.  */
    rule rl_preprocessing;
      let {lv_input, lv_bias} = ff_input.first;
      let lv_operation = ff_input_operation.first;
      ff_input.deq;
      ff_input_operation.deq;
    endrule: rl_preprocessing

    interface put_input = interface Put
      method Action put(cfloat_1_5_2 in, Bit#(6) bias, Operation operation);
        ff_input.enq(tuple2(in, bias));
        ff_input_operation.enq(operation);
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
