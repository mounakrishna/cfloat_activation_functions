package Testbench; 
  `include "Logger.bsv"
  import FIFO :: * ;
  import FIFOF :: * ;
  import SpecialFIFOs :: * ;
  import RegFile :: * ;
  import types :: *;
  import activation_compute :: *;
  `define index_size 10
  `define entry_size 50
  `define stim_size 123

  (*synthesize*)
  module mkTestbench(Empty);
    RegFile#(Bit#(`index_size) , Bit#(`entry_size)) stimulus <- mkRegFileLoad("input.txt", 0, `stim_size-1);
//    let fadd <- mk_fpu_add_sub_sp_instance;
    let fcompute <- mkactivation_compute;

    //FIFOF#(Tuple2#(Bit#(`FLEN), Bit#(5))) ff_golden_output <- mkSizedFIFOF(1);
    FIFOF#(Tuple2#(Bit#(8), Bit#(8))) ff_golden_output <- mkSizedFIFOF(1);

    Reg#(Bit#(8)) rg_e_out_1 <- mkReg(0);
    Reg#(Bit#(8)) rg_inp_1 <- mkReg(0);

    Reg#(Bit#(8)) rg_e_out_2 <- mkReg(0);
    Reg#(Bit#(8)) rg_inp_2 <- mkReg(0);

    Reg#(Bit#(8)) rg_e_out_3 <- mkReg(0);
    Reg#(Bit#(8)) rg_inp_3 <- mkReg(0);

    //Reg#(int) cycle <- mkReg(0);
    Reg#(Bit#(`index_size)) read_index <- mkReg(0);
    Reg#(Bit#(`index_size)) golden_index <- mkReg(0);

/*   rule count_cycle;
      cycle <= cycle+1;
      $display("cycle no, is %d", cycle);
      if(cycle >50)
      begin
         $finish(0);
      end
   endrule
*/

    Reg#(Bit#(32)) rg_cycle <- mkReg(0);
    //Reg#(Bool) _ready <- mkReg(False);

    //rule cycle;
    //  if(rg_cycle==3)
    //   _ready<=True;
    //  else
    //   rg_cycle<=rg_cycle+1;
    //endrule

    /*doc:rule: */
    rule rl_pick_stimulus_entry;      
      let _e = stimulus.sub(read_index);
      Bit#(8) _output = truncate(_e);
      _e = _e >> 8;
      Bit#(8) _inp = truncate(_e);
      _e = _e >> 8;

      let op = Cfloat_1_5_2{sign: _inp[7], exp: unpack(_inp[6:2]), mantissa: _inp[1:0]};
      //let out = Cfloat_1_5_2{sign: _output[7], exp: unpack(_output[6:2]), mantissa: _output[1:0]};

      fcompute.ma_input(op, 0, LeakyReLu);
      ff_golden_output.enq(tuple2(_inp, _output));
      //rg_e_out_1 <= _output;
      //rg_inp_1 <= _inp;
    endrule

    //rule r1;
    //  rg_e_out_2 <= rg_e_out_1;
    //  rg_inp_2 <= rg_inp_1;
    //endrule

    //rule r2;
    //  rg_e_out_3 <= rg_e_out_2;
    //  rg_inp_3 <= rg_inp_2;
    //endrule

    /*doc:rule: */
    rule rl_check_output;
      let x <- fcompute.mav_output();
      rg_cycle <= rg_cycle + 1;
      //$display("cycle: %d", rg_cycle);
      if(x matches tagged Valid .lv_output) begin
        let out = lv_output.out;
        let flags = lv_output.flags;
        let {in, e_out} = ff_golden_output.first;
        //let in = rg_inp_3;
        //let e_out = rg_e_out_3;
        Bit#(8) _out = {pack(out.sign), pack(out.exp), out.mantissa};
        ff_golden_output.deq;
        if( _out != e_out) begin
          `logLevel( tb, 0, $format("TB: Outputs mismatch[%d]. in: %h e_out:%h out:%h,flag %h", golden_index, in, e_out, _out, flags))
//          $finish(0);
        end
        else begin
          `logLevel( tb, 0, $format("TB: Outputs match[%d]. in: %h e_out:%h out:%h,flag %h", golden_index, in, e_out, _out, flags))
            //`logLevel( tb, 0, $format("TB: Outputs match [%d], g: %h R: %h  FLAGS G: %h,  R:  %h", golden_index,e_out, _out,e_flags,flags))
        end
        golden_index <= golden_index + 1;

        read_index <= read_index + 1;
		    if(read_index == `stim_size-1) begin
          $display("read_index is %d", read_index);
	        $finish(0); 
        end
      end
    endrule
  endmodule
endpackage

