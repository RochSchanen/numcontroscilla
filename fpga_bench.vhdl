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
use work.all;

-------------------------------------------------

entity fpga_bench is
end fpga_bench;

-------------------------------------------------

architecture fpga_bench_arch of fpga_bench is

    -- configuration
    constant SIZE : integer := 4;
    
    -- signals
    signal r : std_logic; -- reset
    signal c : std_logic; -- clock
    signal q : std_logic_vector(SIZE-1 downto 0); -- value
    signal o : std_logic; -- carry

begin

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(c);

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(5 ns)
        port map(r);

    -- instanciate pipelined counter
    pl_acc_1: entity placc
        generic map(SIZE)
        port map(r, c, "1111", q, o);

end fpga_bench_arch;

-------------------------------------------------
