---------------------------------------------------------------------

-- file: placc.vhdl
-- content: pipelined accumulator of arbitrary size
-- Created: 2020 august 14
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size has been tested for integers larger than 4

---------------------------------------------------------------------

-------------------------------------------------
--                PIPELINED ACCUMULATOR
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

-------------------------------------------------

entity placc is
    generic (size : integer := 4); -- accumulator size
    port (r : in  std_logic;       -- reset (active low)
          t : in  std_logic;       -- trigger (rising edge)
          i : in  std_logic_vector(size-1 downto 0);  -- increment value
          o : out std_logic_vector(size-1 downto 0);  -- accumulator output
          c : out std_logic);                         -- carry out
end entity placc;

-------------------------------------------------

architecture placc_arch of placc is

    -- signals
    signal cc : std_logic_vector(size   downto 0); -- carry lines
    signal ii : std_logic_vector(size-1 downto 0); -- adders input
    signal oo : std_logic_vector(size-1 downto 0); -- adders ouput

begin

    -- integrator carry in is always zero
    cc(0) <= '0';

    -- for each data bit: 
    --   . one input pipeline
    --   . one adder
    --   . one output pipeline

    NETWORK : for n in 0 to size-1 generate

        ipl : entity fifobuf
            generic map (n)
            port map (r, t, i(n), ii(n));

        add : entity addsync
            port map (r, t, ii(n), oo(n), cc(n), oo(n), cc(n+1));

        opl : entity fifobuf
            generic map (size-n)
            port map (r, t, oo(n), o(n));

    end generate NETWORK;

    -- set overload flag (carry out)
    c <= cc(size);

end architecture placc_arch;

-------------------------------------------------