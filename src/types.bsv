/*
Details:
Has all the common structure, enums used across all the modules in this repo

Author: Mouna Krishna
email: mounakrishna27121999@gmail.com
*/
package types;

  typedef struct {
    Bit#(1) sign; // 1 - Negative, 0 - Positive
    Int#(5) exp;
    Bit#(2) mantissa;
  } cfloat_1_5_2 deriving(Bits, Eq, FShow);

  typedef enum {Tanh, Sigmoid, ReLu, SeLu, NONE} Operation deriving(Bits, Eq, FShow);
endpackage
