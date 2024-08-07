@echo off

set STOP_TIME=100ns

rem -------
rem analyze
rem -------

echo analyse .\bench\*
ghdl -a .\bench\benchclock.vhdl
ghdl -a .\bench\benchreset.vhdl
ghdl -a --ieee=synopsys .\bench\benchrom.vhdl

echo analyse .\nco\*
ghdl -a .\nco\fifobuf.vhdl
ghdl -a .\nco\addsync.vhdl
ghdl -a .\nco\plcnt.vhdl
ghdl -a .\nco\placc.vhdl
ghdl -a .\nco\plnco.vhdl

echo analyse .\plpr\*
ghdl -a .\plpr\plpr.vhdl

echo analyse plpr_bench.vhdl
rem ghdl -a -fsynopsys .\fpga_bench.vhdl
ghdl -a --ieee=synopsys .\plpr_bench.vhdl

rem ---------
rem elaborate
rem ---------

echo elaborate plpr_bench
rem ghdl -e -fsynopsys fpga_bench
ghdl -e --ieee=synopsys plpr_bench

rem --------------
rem run and export
rem --------------

echo run
ghdl -r --ieee=synopsys plpr_bench --stop-time=%STOP_TIME% --vcd=.outputs\bench.vcd
echo done.
