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
    constant FILENAME  : string  := "./bench/SIN256x8.txt";
    constant ADDRSIZE  : integer := 8;
    constant DATASIZE  : integer := 8;

    -- signals
    signal r : std_logic; -- reset
    signal c : std_logic; -- clock
    signal a : std_logic_vector(ACCSIZE+CNTSIZE-1 downto 0); -- address
    signal o : std_logic; -- carry
    signal q : std_logic_vector(DATASIZE-1 downto 0); -- output

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
        generic map(ACCSIZE, CNTSIZE)
        port map(r, c, "0111", a, o);

    -- instanciate bench rom
    bench_rom_1: entity benchrom
        generic map(FILENAME, ADDRSIZE, DATASIZE)
        port map(a, r, q);

end fpga_bench_arch;

-------------------------------------------------
