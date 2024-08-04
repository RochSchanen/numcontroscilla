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
    
    -- defines bit products in a double array of terms
    type terms is array (0 to size-1, 0 to size-1) of std_logic;

    -- terms signals
    signal pp: terms;

begin

    -- generate bit products network
    SUBNET_A: for i in 0 to 3 generate
        SUBNET_B: for j in 0 to 3 generate
            pp(i, j) <= a(i) AND b(j);
        end generate;
    end generate;

    -- 0
    p(0) <= pp(0, 0);

    -- 1
    p(1) <= pp(1, 0);

    -- 2
    p(2) <= pp(2, 0);

    -- 3
    p(3) <= pp(3, 0);

    -- 4
    p(4) <= pp(3, 1);

    -- 5
    p(5) <= pp(3, 2);

    -- 6
    p(6) <= pp(3, 3);

    -- 7
    p(7) <= '0';

end architecture plpr_arch;

-------------------------------------------------
