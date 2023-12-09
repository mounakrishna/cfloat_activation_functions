/*
Details:
Has all the common structure, enums used across all the modules in this repo

Author: Mouna Krishna
email: mounakrishna27121999@gmail.com
*/
package types;

  typedef struct {
    Bit#(1) sign; // 1 - Negative, 0 - Positive
    Bit#(5) exp;
    Bit#(2) mantissa;
  } Cfloat_1_5_2 deriving(Bits, Eq, FShow);

  typedef struct {
    Bool invalid;
    Bool denormal;
    Bool overflow;
    Bool underflow;
  } Flags deriving(Bits, Eq, FShow);

  typedef enum {Tanh, Sigmoid, LeakyReLu, SeLu} Operation deriving(Bits, Eq, FShow);

  typedef struct {
    Cfloat_1_5_2 inp;
    Int#(6) bias;
    Operation op;
  } PreprocessStageMeta deriving(Bits, Eq, FShow);

  typedef struct {
    Bit#(1) sign;
    Int#(8) act_exp;
    Bit#(3) act_mantissa;
    Int#(6) bias;
    Operation op;
    Flags flags;
  } ComputeStageMeta deriving(Bits, Eq, FShow);

  typedef struct {
    Bit#(1) final_sign;
    Int#(8) final_exp;
    Bit#(3) final_mantissa;
    Bool round_up;
    Int#(6) bias;
    Flags flags;
  } PostprocessStageMeta deriving(Bits, Eq, FShow);

  typedef struct {
    Cfloat_1_5_2 out;
    Flags flags;
  } OutputStageMeta deriving(Bits, Eq, FShow);

endpackage
