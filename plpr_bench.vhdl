---------------------------------------------------------------------

-- file: plpr_bench.vhd
-- content: bench to simulate plpr code
-- Created: 2024 August 4
-- Author: Roch Schanen
-- comments:

---------------------------------------------------------------------

-------------------------------------------------
--          PIPELINED PRODUCT BENCH
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.all;

-------------------------------------------------

entity plpr_bench is
end plpr_bench;

-------------------------------------------------

architecture plpr_bench_arch of plpr_bench is

    -- configuration

    constant FACTORSIZE : integer := 4;

    -- signals
    signal r : std_logic; -- reset
    signal t : std_logic; -- clock
    signal q : std_logic_vector(2*FACTORSIZE-1 downto 0); -- output

    signal a : std_logic_vector(7 downto 0); -- counter output
    signal o : std_logic;

begin

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(t);

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(3 ns)
        port map(r);

    -- instanciate bench counter
    bench_counter_1: entity benchcounter
        generic map(8)
        port map(r, t, a);

    -- instanciate pipelined nco
    pl_pr_1: entity plpr
        generic map(FACTORSIZE)
        port map(r, t, "1101", "1101", q);

end plpr_bench_arch;

-------------------------------------------------
