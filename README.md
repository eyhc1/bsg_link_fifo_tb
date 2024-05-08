# BSG-LINK FIFO TESTBENCH (WIP)
A [test](https://docs.google.com/document/d/1wTQ0qkmZlwADg6h_bS0_GCiqUVJLztxErb6ino6rpnw/edit) repository for the BSG-LINK FIFO IP using CocoTB. The testbench is written in Python and uses the CocoTB library to simulate the twofer FIFO.
The repo is mainly to familiarize with verifications using CocoTB by testing the already tested BSG STLs. Also to test the CocoTB infrastructure integration 
into ACME structures.
Potentially a pull request can be made to the BSG repo to include the testbench in the main repo.

## Prerequisites
- Python 3.6 or higher
- CocoTB
- Any other preperation needed found in the [This documentation](https://docs.google.com/document/d/1wTQ0qkmZlwADg6h_bS0_GCiqUVJLztxErb6ino6rpnw/edit#heading=h.1oy07biebcx8)

## Running the tests
Before running any tests, make sure you have cloned the [basejump_stl repo](https://github.com/bespoke-silicon-group/basejump_stl.git) and have the path set correctly in the `Makefile` in the `BASEJUMP_STL_DIR` variable.
There is a Makefile in the root directory that can be used to run the tests. The Makefile has the following targets:
- `make`: Runs the testbench and everything else
- `make st-clean`: Cleans the simulation files if it is running in local/windows environment
- `make view-wave`: Opens the waveform viewer if it is using ModelSim
- `make ee-verdi`: View the waveform using Verdi if it is using Verdi on a Linux machine/server
- `make ee-verdi-cov`: Visualize the coverage results if it is using Verdi on a Linux machine/server
- `make ee-clean`: Cleans the simulation files if it is using Verdi on a Linux machine/server

## TODOs/Issues
- [ ] Achieve 100% functional coverages
- [ ] Verify currrently workflows runs on both Linux and Windows
- [ ] Allow other open-source simulators to be used
- [ ] Automatically get the BSG STLs from the BSG repo