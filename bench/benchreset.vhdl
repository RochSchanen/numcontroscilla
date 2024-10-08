---------------------------------------------------------------------

-- file: benchreset.vhdl
-- content: reset switch to be used by the fpga_bench
-- Created: 2024 July 28
-- Author: Roch Schanen
-- comments:
-- Simulate an external reset switch for the FPGA bench.
-- The reset start at a low level and rise after a fixed
-- PERIOD of time and remains high indefinitely (note that
-- this is a purely virtual device).

---------------------------------------------------------------------

-------------------------------------------------
--                BENCH RESET
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------

entity benchreset is

    -- configure reset
    generic (PERIOD: time := 10 ns);

    -- only one output port
    Port ( o : out STD_LOGIC);

-- done
end benchreset;

-------------------------------------------------

architecture benchreset_arch of benchreset is

    -- reset state
    signal s : STD_LOGIC; -- leave uninitialised
    --signal s : STD_LOGIC := '0';

begin

    process

    begin

        -- leave reset signal uninitialised for 1 ns
        -- (used for debugging the start up process:
        -- for example, checking for spurious signals
        -- during start up and remove them where
        -- necessary)
        wait for 1 ns;

        -- set reset state low
        s <= '0';   

        -- wait
        wait for PERIOD;

        -- set reset state high
        s <= '1';

        -- wait forever
        wait;

    end process;

    -- output the reset state
    o <= s;

-- done
end benchreset_arch;

-------------------------------------------------
