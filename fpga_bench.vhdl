---------------------------------------------------------------------

-- file: fpga_bench.vhd
-- content: bench to simulate fpga code
-- Created: 2024 july 28
-- Author: Roch Schanen
-- comments:

---------------------------------------------------------------------

-------------------------------------------------
--                FPGA BENCH
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.benchclock;
use work.benchreset;
use work.fifobuf;

entity fpga_bench is
end fpga_bench;

architecture fpga_bench_arch of fpga_bench is

    -- signals

    signal c : std_logic; -- clock
    signal o : std_logic; -- output
    signal r : std_logic; -- reset

begin

    -- instanciate benchclock

    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(c);

    -- instanciate benchreset

    bench_reset_1: entity benchreset
        generic map(5 ns)
        port map(r);

    -- instanciate fifobuf

    fifo_buffer_1: entity fifobuf
        generic map (5)           -- five flip-flops
        port map (r, c, '1', o);  -- fixed input 1

end fpga_bench_arch;
