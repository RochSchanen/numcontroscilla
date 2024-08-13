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
    constant SIZE : integer := 4;

    -- signals
    signal r : std_logic;                       -- bench reset
    signal t : std_logic;                       -- bench clock
    signal q : std_logic_vector(SIZE downto 0); -- fifostream output

    signal test: std_logic;

begin

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(3 ns)   -- duration
        port map(r);        -- r: reset signal

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(t);        -- t: clock signal

    -- instanciate fifo stream
    fifo_stream_1: entity fifostream
        generic map(SIZE)
        port map(r, t, test, q);

    process
    begin

        wait for 5 ns;
        test <= '0';

        wait for 7 ns;
        test <= '1';

        wait for 7 ns;
        test <= '0';

        wait for 7 ns;
        test <= '1';

        wait;

    end process;


end fifostream_bench_arch;
