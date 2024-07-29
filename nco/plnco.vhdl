---------------------------------------------------------------------

-- file: plnco.vhdl
-- content: pipelined numerically-controlled oscillator of arbitrary size
-- Created: 2020 september 02
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- two generic sizes: the accumulator size and the counter size
-- the full NCO size is the catenation of the two.

---------------------------------------------------------------------

-------------------------------------------------
--  PIPELINED NUMERICALLY CONTROLLED OSCILLATOR
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

-------------------------------------------------

entity plnco is
    generic (
        ACCSIZE : integer := 4;  -- accumulator size
        CNTSIZE : integer := 4); -- counter size
    port (r : in  std_logic;     -- reset (active low)
          t : in  std_logic;     -- trigger (rising edge)
          i : in std_logic_vector(ACCSIZE-1 downto 0);
          o : out std_logic_vector(CNTSIZE+ACCSIZE-1 downto 0);
          c : out std_logic);    -- carry out
end entity plnco;

-------------------------------------------------

architecture plnco_arch of plnco is

    -- signals
    signal oo : std_logic_vector(ACCSIZE-1 downto 0); -- acc output
    signal cc : std_logic;                            -- acc carry

begin

    -- instanciate accumulator
    acc : entity placc
        generic map (ACCSIZE)
        port map (r, t, i, oo, cc);

    -- instanciate extra pipelines
    NETWORK : for n in 0 to ACCSIZE-1 generate
        opl : entity fifobuf
            generic map (CNTSIZE)
            port map (r, t, oo(n), o(n));
    end generate NETWORK;

    -- instanciate counter
    cnt: entity plcnt
        generic map (CNTSIZE)
        port map (r, t, cc, o(CNTSIZE-1+ACCSIZE downto ACCSIZE), c);

end architecture plnco_arch;

-------------------------------------------------