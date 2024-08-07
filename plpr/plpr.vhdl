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
    
    type PP is array (0 to 3, 0 to 3) of std_logic;

    -- sums
    signal di: PP; -- add sync input b
    signal do: PP; -- add sync sum out
    signal ci: PP; -- add sync carry in
    signal co: PP; -- add sync carry out
    signal pi: PP; -- fifo pipe input
    
    -- carry
    signal cdo: PP; -- add sync sum out
    signal cc: PP; -- add sync carry out

begin

    pi(0, 0) <= a(0) AND b(0);
    pi(0, 1) <= a(0) AND b(1);
    pi(0, 2) <= a(0) AND b(2);
    pi(0, 3) <= a(0) AND b(3);
    pi(1, 0) <= a(1) AND b(0);
    pi(1, 1) <= a(1) AND b(1);
    pi(1, 2) <= a(1) AND b(2);
    pi(1, 3) <= a(1) AND b(3);
    pi(2, 0) <= a(2) AND b(0);
    pi(2, 1) <= a(2) AND b(1);
    pi(2, 2) <= a(2) AND b(2);
    pi(2, 3) <= a(2) AND b(3);
    pi(3, 0) <= a(3) AND b(0);
    pi(3, 1) <= a(3) AND b(1);
    pi(3, 2) <= a(3) AND b(2);
    pi(3, 3) <= a(3) AND b(3);



    -- 0
    fifo_00: entity fifobuf generic map(0) port map(r, t, pi(0, 0), di(0, 0));
    -- 1
    fifo_01: entity fifobuf generic map(1) port map(r, t, pi(0, 1), di(0, 1));
    fifo_10: entity fifobuf generic map(2) port map(r, t, pi(1, 0), di(1, 0));
    -- 2
    fifo_02: entity fifobuf generic map(2) port map(r, t, pi(0, 2), di(0, 2));
    fifo_11: entity fifobuf generic map(3) port map(r, t, pi(1, 1), di(1, 1));
    fifo_20: entity fifobuf generic map(4) port map(r, t, pi(2, 0), di(2, 0));
    -- 3
    fifo_03: entity fifobuf generic map(3) port map(r, t, pi(0, 3), di(0, 3));
    fifo_12: entity fifobuf generic map(4) port map(r, t, pi(1, 2), di(1, 2));
    fifo_21: entity fifobuf generic map(5) port map(r, t, pi(2, 1), di(2, 1));
    fifo_30: entity fifobuf generic map(6) port map(r, t, pi(3, 0), di(3, 0));
    -- 4 ---------------------------------------------------------------------
    fifo_13: entity fifobuf generic map(4) port map(r, t, pi(1, 3), di(1, 3));
    fifo_22: entity fifobuf generic map(5) port map(r, t, pi(2, 2), di(2, 2));
    fifo_31: entity fifobuf generic map(6) port map(r, t, pi(3, 1), di(3, 1));
    -- 5
    fifo_23: entity fifobuf generic map(5) port map(r, t, pi(2, 3), di(2, 3));
    fifo_32: entity fifobuf generic map(6) port map(r, t, pi(3, 2), di(3, 2));
    -- 6
    fifo_33: entity fifobuf generic map(6) port map(r, t, pi(3, 3), di(3, 3));



    fifo_0: entity fifobuf generic map(10) port map (r, t,  do(0, 0), p(0));
    fifo_1: entity fifobuf generic map( 8) port map (r, t,  do(1, 0), p(1));
    fifo_2: entity fifobuf generic map( 6) port map (r, t,  do(2, 0), p(2));
    fifo_3: entity fifobuf generic map( 4) port map (r, t,  do(3, 0), p(3));   
    ------------------------------------------------------------------------
    fifo_4: entity fifobuf generic map( 3) port map (r, t, cdo(0, 0), p(4));
    fifo_5: entity fifobuf generic map( 2) port map (r, t, cdo(1, 1), p(5));
    fifo_6: entity fifobuf generic map( 1) port map (r, t, cdo(2, 2), p(6));
    fifo_7: entity fifobuf generic map( 0) port map (r, t, cdo(3, 3), p(7));



    -- 0
    async_00: entity addsync port map(r, t,       '0', di(0, 0),      '0',  do(0, 0), co(0, 0));
    -- 1
    async_01: entity addsync port map(r, t,       '0', di(0, 1), co(0, 0),  do(0, 1), co(0, 1));
    async_10: entity addsync port map(r, t,  do(0, 1), di(1, 0),      '0',  do(1, 0), co(1, 0));
    -- 2
    async_02: entity addsync port map(r, t,       '0', di(0, 2), co(0, 1),  do(0, 2), co(0, 2));
    async_11: entity addsync port map(r, t,  do(0, 2), di(1, 1), co(1, 0),  do(1, 1), co(1, 1));
    async_20: entity addsync port map(r, t,  do(1, 1), di(2, 0),      '0',  do(2, 0), co(2, 0));
    -- 3
    async_03: entity addsync port map(r, t,       '0', di(0, 3), co(0, 2),  do(0, 3), co(0, 3));
    async_12: entity addsync port map(r, t,  do(0, 3), di(1, 2), co(1, 1),  do(1, 2), co(1, 2));
    async_21: entity addsync port map(r, t,  do(1, 2), di(2, 1), co(2, 0),  do(2, 1), co(2, 1));
    async_30: entity addsync port map(r, t,  do(2, 1), di(3, 0),      '0',  do(3, 0), co(3, 0));
    -- 4 ---------------------------------------------------------------------------------------
    async_13: entity addsync port map(r, t,       '0', di(1, 3), co(0, 3),  do(1, 3), co(1, 3));
    async_22: entity addsync port map(r, t,  do(1, 3), di(2, 2), co(1, 2),  do(2, 2), co(2, 2));
    async_31: entity addsync port map(r, t,  do(2, 2), di(3, 1), co(2, 1),  do(3, 1), co(3, 1));
    bsync_00: entity addsync port map(r, t,  do(3, 1),      '0', co(3, 0), cdo(0, 0), cc(0, 0));
    -- 5
    async_23: entity addsync port map(r, t,       '0', di(2, 3), co(1, 3),  do(2, 3), co(2, 3));
    async_32: entity addsync port map(r, t,  do(2, 3), di(3, 2), co(2, 2),  do(3, 2), co(3, 2));
    bsync_10: entity addsync port map(r, t,  do(3, 2),      '0', co(3, 1), cdo(1, 0), cc(1, 0));
    bsync_11: entity addsync port map(r, t, cdo(1, 0),      '0', cc(0, 0), cdo(1, 1), cc(1, 1));
    -- 6
    async_33: entity addsync port map(r, t,       '0', di(3, 3), co(2, 3),  do(3, 3), co(3, 3));
    bsync_20: entity addsync port map(r, t,  do(3, 3),      '0', co(3, 2), cdo(2, 0), cc(2, 0));
    bsync_21: entity addsync port map(r, t, cdo(2, 0),      '0', cc(1, 0), cdo(2, 1), cc(2, 1));
    bsync_22: entity addsync port map(r, t, cdo(2, 1),      '0', cc(1, 1), cdo(2, 2), cc(2, 2));
    -- 7
    bsync_30: entity addsync port map(r, t,       '0',      '0', co(3, 3), cdo(3, 0), cc(3, 0));
    bsync_31: entity addsync port map(r, t, cdo(3, 0),      '0', cc(2, 0), cdo(3, 1), cc(3, 1));
    bsync_32: entity addsync port map(r, t, cdo(3, 1),      '0', cc(2, 1), cdo(3, 2), cc(3, 2));
    bsync_33: entity addsync port map(r, t, cdo(3, 2),      '0', cc(2, 2), cdo(3, 3), cc(3, 3));

end architecture plpr_arch;

-------------------------------------------------
