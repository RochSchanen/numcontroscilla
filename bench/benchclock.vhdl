---------------------------------------------------------------------

-- file: benchclock.vhd
-- content: clock to be used by the fpga_bench
-- Created: 2024 july 28
-- Author: Roch Schanen
-- comments:
-- Simulate an external clock for the FPGA bench.
-- The clock alternates state between 0 and 1. It
-- waits HALF_PERIOD between states, and repeats
-- indefinitely (note that this is a purely virtual
-- device).

---------------------------------------------------------------------

-------------------------------------------------
--                BENCH CLOCK
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------

entity benchclock is

    -- configure clock
    generic (HALF_PERIOD: time := 5 ns);

    -- only one output port
    Port ( o : out STD_LOGIC);

-- done
end benchclock;

-------------------------------------------------

architecture benchclock_arch of benchclock is

    -- define clock state
    signal s : STD_LOGIC := '0';

begin

    process

    begin

        -- repeat indefinitely
        while true loop

            -- set clock state high
            s <= '1';

            -- wait
            wait for HALF_PERIOD;

            -- set clock state low
            s <= '0';

            -- wait
            wait for HALF_PERIOD;

        -- and again
        end loop;

    end process;

    -- output the clock state
    o <= s;

-- done
end benchclock_arch;

-------------------------------------------------
