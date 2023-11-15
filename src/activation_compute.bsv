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
    FIFOF#(Tuple3#(cfloat_1_5_2, Bit#(6), Operation)) ff_input <- mkFIFOF();

    /*doc: fifo: FIFO to store the outputs*/
    FIFOF#(Maybe#(cfloat_1_5_2)) ff_output <- mkFIFOF();

    /*doc: rule: Get the inputs and start the required operation.  */
    rule rl_compute_activation;
      let inputs = ff_input.first;
      ff_input.deq;
    endrule: rl_compute_activation

    interface put_input = interface Put
      method Action put(cfloat_1_5_2 in, Bit#(6) bias, Operation operation);
        ff_input.enq(tuple3(in, bias, operation));
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
