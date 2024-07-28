---------------------------------------------------------------------

-- file: fpga_bench.vhd
-- content: bench to simulate fpga code
-- Created: 2024 july 28
-- Author: Roch Schanen
-- comments: simulate external clock, input and outputs ports.

---------------------------------------------------------------------

-------------------------------------------------
--                FPGA BENCH
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.benchclock;

entity fpga_bench is
end fpga_bench;

architecture fpga_bench_arch of fpga_bench is

    -- signals

    signal c : std_logic;

begin

    -- instanciate benchclock

    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(c);

end fpga_bench_arch;
