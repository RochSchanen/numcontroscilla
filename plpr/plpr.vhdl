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
          a : in  std_logic_vector(size-1 downto 0);    -- input A (4)
          b : in  std_logic_vector(size-1 downto 0);    -- input B (4)
          p : out std_logic_vector(2*size-1 downto 0)); -- product AB (8)
end entity plpr;

-------------------------------------------------

architecture plpr_arch of plpr is
    
    signal C0: std_logic_vector(0 to 6);
    signal C1: std_logic_vector(1 to 6);
    signal C2: std_logic_vector(2 to 6);
    signal C3: std_logic_vector(3 to 6);

begin

    -- 0
    p(0) <= '0';

    -- 1
    p(1) <= '0';

    -- 2
    p(2) <= '0';

    -- 3
    p(3) <= '0';

    -- 4
    p(4) <= '0';

    -- 5
    p(5) <= '0';

    -- 6
    p(6) <= '0';

    -- 7
    p(7) <= '0';

end architecture plpr_arch;

-------------------------------------------------
