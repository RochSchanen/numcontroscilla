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
    constant ACCSIZE   : integer := 4;
    constant CNTSIZE   : integer := 4;

    -- signals
    signal r : std_logic; -- reset
    signal c : std_logic; -- clock
    signal q : std_logic_vector(ACCSIZE+CNTSIZE-1 downto 0); -- value
    signal o : std_logic; -- carry

begin

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(c);

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(3 ns)
        port map(r);

    -- instanciate pipelined counter
    pl_nco_1: entity plnco
        generic map(ACCSIZE, CNTSIZE) -- 4 and 4
        port map(r, c, "1111", q, o);

end fpga_bench_arch;

-------------------------------------------------
