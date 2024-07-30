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

- PLACC (nco): This is a pipelined accumulator. The accumulator adds an new input value every clock pulse. It is synchronous with the rising edge of the clock. The accumulator can be asynchronously cleared with the reset signal which is active when low. It is pipelined, therefore, there is a fixed latency of N clock pulses where N is the size of the counter. The result of the current input summation is available N cycle later at the output. However, the longest of the path delay is very short which allows high clock rates. And thanks to this high clock rates, the time shift remains small. It is irrelevant for most purposes, and can be perfectly characterised when necessary. PLACC has been tested for integers values larger than 4 (30 July 2024).

- PLNCO (nco): This is the pipelined NCO. It is build by catenation of one accumulator and one counter. The accumulator part for adjusting the period of the oscillator with precision, the counter part to fit the required size of the data table. A NCO with a size larger than a table size can be used by cutting off the lowest significant bits, but preserving a high resolution of the frequency required. There is some optimisation to choose between the frequency resolution, the maximum available clock rate and the signal resolution (30 July 2024).

- BENCHROM (bench): The NCO output is normally used as a pointer to the table that defines the periodic signal to be generated. The NCO generates the phase of the signal, and the table output is the signal amplitude at that phase. The table is generally stored in some part of the FPGA dedicated as memory. The memory access usually depends on the manufacture. Here, a memory entity is made available in the bench library that is fairly generic. The VHDL description of the memory is fixed while content of the memory is configured in a separate text file. A rom content that form a harmonic signal can be generated using the simple python tool **makerom.py**. Two parameters are required: The table address size and the data size. (30 July 2024).

### Libraries:

- Bench components are grouped in the <u>./bench</u> directory (29 July 2024).
- The numerically controlled oscillator components are grouped in the <u>./nco</u> directory (29 July 2024).

### note to self:

- It seems that when libraries are collected into packages the keyword **entity** (see for example plcnt.vhdl line 53, 56) is not required. Some more reading is required on packages and compiling and using libraries (29 July 2024).
