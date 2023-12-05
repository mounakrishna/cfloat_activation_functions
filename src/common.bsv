package common;

  function Bool isZero(Bit#(5) exp, Bit#(2) man);
    return (exp == 0 && man == 0);
  endfunction

  function Bool isDenormal();
    return (exp == 0 && man != 0);
  endfunction
endpackage
