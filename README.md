<!-- file: README.md -->
<!-- content: readme file for numcontroscilla project -->
<!-- Created: 2024 july 28 -->
<!-- Author: Roch Schanen -->

NUMCONTROSCILLA
---

	Motivation

This is an attempt at developing a numerically controlled oscillator.
This first part is the development of the code to configure an FPGA.
The code is simulated using "GHDL".
The simulation produces an output in the form of a VCD file.
This file can be displayed using "GTKwave" (28 July 2024).

	Status

### Written:

- BENCHCLOCK (bench): This is a virtual clock (not to be implemented by the FPGA an external clock). This is used on the bench to test the rest of the FPGA code (here the nco library). The clock can be configure by defining its half period. It outputs symmetric high-low pulses indefinitely from the start of the simulation. The output level is high at the start of the simulation (28 July 2024).

- BENCHRESET (bench): This is a reset signal set at the start of the simulation. A low level is asserted (after 1ns) during a length of time that can be configured. Then, the output is raised indefinitely for the rest of the simulation. Again, this is a virtual entity that is used to test the FPGA code (28 July 2024).

- FIFOBUF (nco): This generates a single bit <u>first-in first-out</u> buffer. The length of the buffer can be configured. A buffer of length <u>N</u> (where N>0) generates N flip-flops linked in a chain. If N=0, the buffer is empty, and the input port links straight to the output port (28 July 2024).

- ADDSYNC (nco): This is a single bit adder which output is registered on a trigger clock, with an asynchronous reset, and carry flags. This is used by the pipelined counter and the pipelined accumulator (29 July 2024).

- PLCNT (nco): This is a pipelined counter. The counter counts on each rising edge of the clock signal when the count enable (carry in) input level is high. There is a fixed latency of N clock pulses where N is the size of the counter. However, the longest of the path delay is very short which allows high clock rates. After the initial latency, a new count value is available every new clock pulse. The only advantage of this design is to be able to use high clock rates (29 July 2024).

### Libraries:

- Bench components are grouped in the <u>./bench</u> directory (29 July 2024).
- The numerically controlled oscillator components are grouped in the <u>./nco</u> directory (29 July 2024).

### note to self:

- It seems that when libraries are collected into packages the keyword **entity** (see for example plcnt.vhdl line 53, 56) is not required. Some more reading is necessary about packages and compiling libraries (29 July 2024).
