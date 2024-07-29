---------------------------------------------------------------------

-- file: plcnt.vhdl
-- content: pipelined counter of arbitrary size
-- Created: 2020 september 02
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low

---------------------------------------------------------------------

-------------------------------------------------
--                PIPELINED COUNTER
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

-------------------------------------------------

entity plcnt is
    generic (size : integer := 4); -- counter size
    port (r : in  std_logic;       -- reset (active low)
          t : in  std_logic;       -- trigger (rising edge)
          i : in  std_logic;       -- enable counter (carry in)
          o : out std_logic_vector(size-1 downto 0);
          c : out std_logic);      -- overload (carry out)
end entity plcnt;

-------------------------------------------------

architecture plcnt_arch of plcnt is

    -- signals
    signal cc : std_logic_vector(size   downto 0); -- carry lines
    signal oo : std_logic_vector(size-1 downto 0); -- adders ouput

begin

    -- count enable
    cc(0) <= i;

    -- for each data bit: 
    --   . one adder 
    --   . one output pipeline

    NETWORK : for n in 0 to size-1 generate

        add : entity addsync
            port map (r, t, '0', oo(n), cc(n), oo(n), cc(n+1));

        opl : entity fifobuf
            generic map (size-n)
            port map (r, t, oo(n), o(n));

    end generate NETWORK;

    -- set overload flag (carry out)
    c <= cc(size);

end architecture plcnt_arch;

-------------------------------------------------
