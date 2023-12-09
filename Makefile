#/////////////////////////////////////////////
#// see LICENSE.iitm
#// Makefile for testbenches in fpu_pipelined
#/////////////////////////////////////////////

TOP_MODULE:=mkTestbench
TOP_FILE:=Testbench.bsv
TOP_DIR:=./testbench
CXXFLAGS = -I include -std=c++11 -O3 -I/home/shakti/anaconda3/envs/spy/include/python3.6m -I/home/shakti/anaconda3/envs/spy/include/python3.6m  -Wno-unused-result -Wsign-compare -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -O3 -pipe  -fdebug-prefix-map==/usr/local/src/conda/- -fdebug-prefix-map==/usr/local/src/conda-prefix -fuse-linker-plugin -ffat-lto-objects -flto-partition=none -flto -DNDEBUG -fwrapv -O3 -Wall
VERILATOR_FLAGS = --stats -O3 -CFLAGS -O3 -LDFLAGS "-static" --x-assign fast --x-initial fast \
--noassert sim_main.cpp --bbox-sys -Wno-STMTDLY -Wno-UNOPTFLAT -Wno-WIDTH \
-Wno-lint -Wno-COMBDLY -Wno-INITIALDLY --autoflush $(coverage) $(trace) --threads $(THREADS) \
-DBSV_RESET_FIFO_HEAD -DBSV_RESET_FIFO_ARRAY

BSVCOMPILEOPTS:= -check-assert  -keep-fires -opt-undetermined-vals -remove-false-rules -remove-empty-rules -remove-starved-rules 
BSVLINKOPTS:=-parallel-sim-link 8 -keep-fires
VERILOGDIR:=./verilog/
BSVBUILDDIR:=./bsv_build/
BSVOUTDIR:=./bin

STIM_SIZE=7496191
INDEX_SIZE=23
FLEN=32
ENTRY_SIZE=104

BSVINCDIR:=.:%/Libraries:..:.:./src:./testbench:./verif
define_macros = -D simulate -D stim_size=$(STIM_SIZE) -D index_size=$(INDEX_SIZE) -D FLEN$(FLEN)\
								-D denormal_support -D rounding_mode=$(ROUNDING_MODE_BSV) -D fpu_hierarchical
# open bsc changes
BSC_DIR := $(shell which bsc)
BSC_VDIR:=$(subst /bin/bsc,/,${BSC_DIR})bin/../lib/Verilog
BSC_VIVADODIR:=$(subst /bin/bsc,/,${BSC_DIR})bin/../lib/Verilog.Vivado

.PHONY: simulate
simulate:
	@echo Simulation...
	@exec ./$(BSVOUTDIR)/out +fullverbose
	@echo Simulation finished

.PHONY: generate_verilog 
generate_verilog: 
	@echo Compiling $(TOP_MODULE) in verilog ...
	@mkdir -p $(VERILOGDIR); 
	@mkdir -p $(BSVBUILDDIR); 
	@echo "old_define_macros = $(define_macros)" > old_vars
	bsc -u -verilog -elab -remove-dollar +RTS -K4000M -RTS -vdir $(VERILOGDIR) -bdir $(BSVBUILDDIR)\
  $(define_macros) -D verilog=True $(BSVCOMPILEOPTS) $(VERILOG_FILTER) \
  -p $(BSVINCDIR) -g $(TOP_MODULE) $(TOP_DIR)/$(TOP_FILE)  || (echo "BSC COMPILE ERROR"; exit 1) 
	@cp ${BSC_VIVADODIR}/RegFile.v $(VERILOGDIR)  
	@cp ${BSC_VIVADODIR}/BRAM1Load.v $(VERILOGDIR)
	@cp ${BSC_VIVADODIR}/BRAM2BELoad.v $(VERILOGDIR)
	@cp ${BSC_VIVADODIR}/BRAM2.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/FIFO2.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/FIFO1.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/FIFO10.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/RevertReg.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/FIFO20.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/FIFOL1.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/SyncFIFO.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/Counter.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/SizedFIFO.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/ResetEither.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/MakeReset0.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/ClockInverter.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/SyncReset0.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/MakeClock.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/SyncFIFO1.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/RegFileLoad.v $(VERILOGDIR)
	@cp ${BSC_VDIR}/ConstrainedRandom.v ./verilog/


.PHONY: link_verilator
link_verilator: 
	@echo "Linking $(TOP_MODULE) using verilator"
	@mkdir -p bin obj_dir
	@echo "#define TOPMODULE V$(TOP_MODULE)" > sim_main.h
	@echo '#include "V$(TOP_MODULE).h"' >> sim_main.h
	@verilator --cc $(TOP_MODULE).v $(VERILATOR_FLAGS) -y $(VERILOGDIR) --exe
	@ln -f -s ../bsv_testbench/sim_main.cpp obj_dir/sim_main.cpp
	@ln -f -s ../sim_main.h obj_dir/sim_main.h
	@make -j8 -C obj_dir -f V$(TOP_MODULE).mk
	@cp obj_dir/V$(TOP_MODULE) bin/out

.PHONY: clean
clean:
	rm -rf *.log $(BSVOUTDIR) $(BSVBUILDDIR) obj_dir
	rm -f *.jou rm *.log
	rm -rf verification/workdir/*
	rm -rf *.bo *.ba old_vars

clean_verilog: clean 
	rm -rf verilog/
	rm -rf fpga/
	rm -rf INCA*
	rm -rf work
	rm -f ./ncvlog.*
	rm -f irun.*

.PHONY: full_clean
full_clean: clean
	rm -rf verilog fpga 

.PHONY: release 
release:
	rm -rf $(REL_DIR)
	mkdir -p $(REL_DIR)
	mv mk_* $(REL_DIR)


