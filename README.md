# cfloat_activation_functions

Implementing Activation functions such as tanh(x), sigmoid(x), ReLu(x) and SeLu(x) using the Tesla's cfloat_1_5_2 datatype  
as a hardware circuit using Bluespec System Verilog (BSV).

Details about the cfloat_1_5_2 datatype can be found in the below link:
https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf

## Sigmoid and Tanh implementation

Since cloat_1_5_2 has minimal range, LUT implementation of inputs indexing the LUT with outputs can be done. There are many  
papers which have done this way.

Then for computing the Tanh(x) we can use the below formula:  
*Tanh(x) = sigmoid(2\*x) - 1*
