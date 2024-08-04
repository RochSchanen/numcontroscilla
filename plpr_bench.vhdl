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
    signal c : std_logic; -- clock
    signal q : std_logic_vector(2*FACTORSIZE-1 downto 0); -- output

begin

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(c);

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(3 ns)
        port map(r);

    -- instanciate pipelined nco
    pl_pr_1: entity plpr
        generic map(FACTORSIZE)
        port map(r, c, "0001", "0001", q);

end plpr_bench_arch;

-------------------------------------------------
