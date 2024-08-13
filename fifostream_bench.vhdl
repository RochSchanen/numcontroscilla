-------------------------------------------------------------------------------

-- file: fifostream_bench.vhd
-- content: bench to simulate fifostream entity
-- Created: 2024 August 12
-- Author: Roch Schanen
-- comments:

-------------------------------------------------
--          FIFO STREAM BENCH
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.all;

-------------------------------------------------

entity fifostream_bench is
end fifostream_bench;

-------------------------------------------------

architecture fifostream_bench_arch of fifostream_bench is

    -- configuration
    constant size : integer := 5;

    -- signals
    signal r : std_logic;                       -- bench reset
    signal t : std_logic;                       -- bench clock
    signal q : std_logic_vector(size downto 0); -- fifostream output

    -- test input
    signal i: std_logic := '0';

begin

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(3 ns)   -- duration
        port map(r);        -- r: reset signal

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(t);        -- t: clock signal

    ---- instanciate fifo stream
    fifo_stream_1: entity fifostream
        generic map(size)
        port map(r, t, i, q);

    process
    begin

        wait for 8 ns;
        i <= '1';

        wait for 40 ns;
        i <= '0';

        wait for 40 ns;
        i <= '1';

        wait;

    end process;


end fifostream_bench_arch;
