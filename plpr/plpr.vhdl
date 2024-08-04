---------------------------------------------------------------------

-- file: plpr.vhdl
-- content: pipelined product
-- Created: 2024 august 4
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size has been tested for integers larger than 4      <- not yet
-- compute the product of two binary numbers

-- positively defined first
-- symmtric size to start, asymetric later

---------------------------------------------------------------------

-------------------------------------------------
--           PIPELINED PRODUCT ARITHMETIC
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

-------------------------------------------------

entity plpr is
    generic (size : integer := 4);                      -- factors size (4 x 4)
    port (r : in  std_logic;                            -- reset (active low)
          t : in  std_logic;                            -- trigger (rising edge)
          a : in  std_logic_vector(size-1 downto 0);    -- input A
          b : in  std_logic_vector(size-1 downto 0);    -- input B
          p : out std_logic_vector(2*size-1 downto 0)); -- product AB
end entity plpr;

-------------------------------------------------

architecture plpr_arch of plpr is

begin

    -- fix null ports:
    -- cc(0) <= '0';

    -- network elements description:
    -- for each data bit: 
    --   . one input pipeline
    --   . one adder
    --   . one output pipeline

    --NETWORK : for n in 0 to size-1 generate

    --    ipl : entity fifobuf
    --        generic map (n)
    --        port map (r, t, i(n), ii(n));

    --    add : entity addsync
    --        port map (r, t, ii(n), oo(n), cc(n), oo(n), cc(n+1));

    --    opl : entity fifobuf
    --        generic map (size-n)
    --        port map (r, t, oo(n), o(n));

    --end generate NETWORK;

    -- generate output ports
    -- set overload flag (carry out)
    --c <= cc(size);

end architecture plpr_arch;

-------------------------------------------------
