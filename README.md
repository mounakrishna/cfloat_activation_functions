# cfloat_activation_functions

Implementing Activation functions such as tanh(x), sigmoid(x), ReLu(x) and SeLu(x) using the Tesla's cfloat_1_5_2 datatype  
as a hardware circuit using Bluespec System Verilog (BSV).

Details about the cfloat_1_5_2 datatype can be found in the below link:
https://cdn.motor1.com/pdf-files/535242876-tesla-dojo-technology.pdf

The repo structure is as follows:
```bash
.
├── Makefile
├── README.md
├── src
│   ├── a.out
│   ├── activation_compute.bsv - Top bluespec module for computation
│   ├── common.bsv - Has common functions used.
│   ├── filename.txt - All possible inputs of cfloat_1_5_2.
│   ├── generateTestData.cpp - Used to generate the LUT data for computation.
│   ├── observations.txt - Observations made from the outputs generated from generateTestData.cpp
│   ├── relu.txt - Outputs for LeakyReLu 
│   ├── selu.txt - Outputs for SeLu
│   ├── selu_lut.bsv - The unique outputs of SeLu are stored in a LUT format in this file.
│   ├── sigmoid.txt - Outputs of sigmoid.
│   ├── sigmoid_lut.bsv - The unique outputs of sigmoid are stored in a LUT format in this file.
│   ├── tanh.txt - Outputs of tanh
│   └── types.bsv - All common types used in the design is present here.
├── testbench
│   ├── Logger.bsv - Display function
│   └── Testbench.bsv - The top level testbench which takes in file with inputs/outputs and checks the functionality
├── verif
│   ├── leakyReLu_ref.txt - Verif text file for leakyReLu
│   ├── leakyReLu_ref_human.txt - Human readable verif text file for leakyReLu
│   ├── reference_model.py - Python reference model to generate input/output combinations
│   └── sigmoid_ref.txt - Verif text file for sigmoid
```

- All the Design decisions and algorithm details are embedded in the code src/activation_compute.bsv

## Verification Methodology

From the verif/reference_model.py, input/output combinations are generated to a text file. 

The text file is taken by the bluespec testbench which feeds data to the design and checks whether the design output matches the expected output taken from the file.

## Steps to run.

A Makefile is present in the home directory.
``` sh
make generate_verilog link_verilator
```

The above command creates a bin/ directory in the home directory of the repo.

Then using reference_model.py, required inputs/outputs are generated for the required bias and stored in a file. 
For example,
```sh
python3 reference_model.py 0
```
The reference_model takes in bias as an argument. Changing of operation needs to be edited manually in the python file.

Once the file is generated, it is copied to the bin/ directory.

Then running the below command will give the run results.
```sh
./out +mtb +l0
```
