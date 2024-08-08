---------------------------------------------------------------------

-- file: benchcounter.vhd
-- content: generic counter
-- Created: 2024 august 08
-- Author: Roch Schanen
-- comments:
-- generic counter device for the FPGA bench,
-- with a rising edge triggered clock input,
-- and aa asynchronous reset. The size of the
-- counter is configurable. The intial counter
-- state is not initialised (use reset).

---------------------------------------------------------------------

-------------------------------------------------
--                BENCH CLOCK
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

-------------------------------------------------

entity benchcounter is

    -- configure clock
    generic (SIZE: integer := 8);

    -- only one output port
    Port (
        r : in  std_logic;                              -- asynchronous reset
        t : in  std_logic;                              -- egded triggered clock
        c : out std_logic_vector (SIZE-1 downto 0));    -- counter state

-- done
end benchcounter;

-------------------------------------------------

architecture benchcounter_arch of benchcounter is
    -- define reset counter state
    constant z : std_logic_vector(SIZE-1 downto 0) := (others => '0');
    -- define counter state
    signal s : std_logic_vector (SIZE-1 downto 0);

begin

    -- sequential logic
    process(r, t)

    begin

        -- asynchronous reset
        if r = '0' then
            s <= z;

        -- rising edge triggered count
        elsif rising_edge(t) then
            s <= std_logic_vector(unsigned(s)+1);

        end if;

    end process;

    -- output counter value
    c <= s;

-- done
end benchcounter_arch;

-------------------------------------------------
