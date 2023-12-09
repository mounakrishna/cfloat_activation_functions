package common;

  /*doc: function: Returns whether the input number is a zero or not */
  function Bool isZero(Bit#(5) exp, Bit#(2) man);
    return (exp == 0 && man == 0);
  endfunction : isZero

  /*doc: function: Returns whether the input number is a denormal number or not.*/
  function Bool isDenormal(Bit#(5) exp, Bit#(2) man);
    return (exp == 0 && man != 0);
  endfunction : isDenormal

  /*doc: funciton: Returns the hiddenBit of the input number depending on whether it is a
         normal number or denormal number.*/
  function Bit#(1) hiddenBit(Bit#(5) exp);
    if (exp == 0)
      return 0;
    else
      return 1;
  endfunction : hiddenBit

  function Reg#(t) readOnlyReg(t r);
   return (interface Reg;
      method t _read = r;
      method Action _write(t x) = noAction;
  endinterface);

endfunction

endpackage
