#!/bin/bash

STOP_TIME="35ns"

# analyze
echo "ghdl -a ..."
ghdl -a ./fpga_bench.vhdl

# elaborate
echo "ghdl -e ..."
ghdl -e fpga_bench

# run and export
echo "ghdl -r ..."
ghdl -r fpga_bench --stop-time=${STOP_TIME} --vcd=fpga_bench.vcd

echo "done."

