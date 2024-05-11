# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# directory for HDL files (for coverage)
export HDL_DIR = $(shell git rev-parse --show-toplevel)/src/hdl

# set simulation dir
export sim = $(shell git rev-parse --show-toplevel)/tools/sim

# If this is running in the University of Washington ECE labs, setup for the EE478 workflow
ifneq ($(findstring ece.uw.edu, $(shell hostname)),)

	# Cadenv Include
	include /home/projects/ee478.2024spr/cadenv/cadenv_ee.mk

	# CAD Tool Paths
	VCS_BIN = $(VCS_HOME)/bin
	VERDI_BIN = $(VERDI_HOME)/bin
	VCS_BIN_DIR = $(VCS_BIN)
	export PATH:=$(PATH):$(VCS_BIN):$(VERDI_BIN)

	# VCS Arguments
	EXTRA_ARGS += +v2k -l $(shell git rev-parse --show-toplevel)/tools/sim/vcs.log
	EXTRA_ARGS += -debug_pp +vcs+vcdpluson
	EXTRA_ARGS += +lint=all,noSVA-UA,noSVA-NSVU,noVCDE,noNS -assert svaext
	EXTRA_ARGS += -cm line+fsm+branch+cond+tgl
	EXTRA_ARGS += -kdb -debug_access+all

	# defaults for ECE is VCS
	SIM ?= vcs

else 

	# If is non-UW ECE lab environment, use custom/other simulator (e.g. ModelSim)
	SIM ?= modelsim

	QUESTASIM_BIN = $(shell which questasim)/../
	export PATH:=$(QUESTASIM_BIN):$(PATH)

	# ModelSim/QuestaSim Arguments
	EXTRA_ARGS += -l $(shell git rev-parse --show-toplevel)/tools/sim/$(shell date +"%Y%m%d%H%M%S").log
endif

WAVES = 1
TOPLEVEL_LANG ?= verilog

#  Python testbench path
export PYTHONPATH := $(shell git rev-parse --show-toplevel)/src/python

# basejump_stl path
export BASEJUMP_STL_DIR = $(shell git rev-parse --show-toplevel)/basejump_stl

# simulator path
export SIM_BUILD = $(shell git rev-parse --show-toplevel)/tools/sim_build

# basejump_stl verilog header include path
EXTRA_ARGS += +incdir+$(BASEJUMP_STL_DIR)/bsg_misc

# basejump_stl verilog filelist
VERILOG_SOURCES += $(BASEJUMP_STL_DIR)/bsg_test/bsg_nonsynth_clock_gen.sv
VERILOG_SOURCES += $(BASEJUMP_STL_DIR)/bsg_test/bsg_nonsynth_reset_gen.sv
VERILOG_SOURCES += $(BASEJUMP_STL_DIR)/bsg_dataflow/bsg_two_fifo.sv
VERILOG_SOURCES += $(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1r1w.sv
VERILOG_SOURCES += $(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1r1w_synth.sv

# testbench verilog filelist
VERILOG_SOURCES += $(HDL_DIR)/bsg_two_fifo_wrapper.sv
VERILOG_SOURCES += $(HDL_DIR)/bsg_two_fifo_cov.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = bsg_two_fifo_wrapper

# MODULE is the basename of the Python test file
MODULE = bsg_two_fifo_tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# for UW EE linux workflows
# VERDI open waveform
ee-verdi:
	verdi -ssf novas.fsdb &

# VERDI open coverages
ee-verdi-cov:
	verdi -cov -covdir tools/sim/simv.vdb &

# **DEPRECATED** DVE open waveform
ee-dve:
	dve -full64 -vpd vcdplus.vpd &

# **DEPRECATED** DVE open coverages
ee-dve-cov:
	dve -full64 -cov -covdir tools/sim/simv.vdb &

# Clean simulation files
ee-clean:
	make clean
	cd tools/sim
	rm -rf __pycache__ DVEfiles *.log vcdplus.vpd results.xml
	rm -rf verdiLog vdCovLog novas.conf novas.fsdb novas.rc novas_dump.log

# for STATIONX local workflows
view-wave:
	vsim -view vsim.wlf

st-clean: clean
	rm -rf *.wlf transcript
	rm -rf work
	rm -rf modelsim.ini
	rm -rf *.vstf
	rm -rf *.vcd
	rm -rf __pycache__
	rm -rf results.xml
	rm -rf *.log

test:
	ls $(shell which modelsim)/../


