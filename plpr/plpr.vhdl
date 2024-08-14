--------------------------------------------------------------------------------
-- file: plpr.vhdl
-- content: pipelined signed product
-- created: 2024 august 10
-- author: roch schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic SIZE has been tested for integers larger than 4 <- only 4 so far
-- compute the product of two signed binary numbers, the result is signed
-- this version has redondant pipeline (pipelines running in parallel
-- that carry the exact same information)

-------------------------------------------------
--      PIPELINED SIGNED PRODUCT ARITHMETIC
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.all;

--------------
entity plpr is
    generic (SIZE : integer := 4);                      -- factors SIZE
    port (r : in  std_logic;                            -- reset (active low)
          t : in  std_logic;                            -- trigger (rising edge)
          a : in  std_logic_vector(SIZE-1 downto 0);    -- input a (4 bits)
          b : in  std_logic_vector(SIZE-1 downto 0);    -- input b (4 bits)
          p : out std_logic_vector(2*SIZE-1 downto 0)); -- product ab (8 bits)
end entity plpr;

---------------------------------
architecture plpr_arch of plpr is

    -------------------------------
    --constant N0  : integer := SIZE;    
    constant N1  : integer := SIZE-1;
    --constant N2  : integer := SIZE-2;

    ---------------------------------
    --constant NN0 : integer := 2*SIZE;
    constant NN1 : integer := 2*SIZE-1;
    --constant NN2 : integer := 2*SIZE-2;

    ---------------------------------------------------------------
    type type_1 is array (0 to N1,  0 to N1)  of std_logic;
    type type_2 is array (0 to NN1, 0 to NN1) of std_logic;
    type type_3 is array (0 to N1,  0 to N1)  of std_logic_vector(2*N1 downto 0);

    ------------------------------------------------------
    -- connections to the bit products array (SIZE x SIZE) 
    -- (the full square is used)
    -- bp is for bit product
    signal bp: type_1;

    -----------------------------------------------------------
    -- connections to the add sync semi-array (SIZE x SIZE x 4)
    -- (top-left triangle plus diagonal means a bit more than half are used)
    -- so is for sum out, co is for carry out
    signal so, co: type_2;

    -------------------------------------------------------------------
    -- vector signals to the fifo stream array (SIZE x SIZE x SIZE x 4)
    -- (only few connections are used, but a clean indexing is necessary)
    signal pp: type_3;

    -----------------------------------------------------------------
    -- returns the n index of bit product from the cell position i, j
    function n(i: integer; j: integer) return integer is    
        variable x: integer;
    begin
        if j > 3 then x := 3; else x := j; end if;
        return x;
    end function;

    --------------------------------------------
    -- returns the m index of bit product from the cell position i, j
    function m(i: integer; j: integer) return integer is    
        variable x: integer;
    begin
        if i-j < SIZE then x := i-j; else x := 3; end if;
        return x;
    end function;

begin


    -- TEMP
    p <= (others => '0');

    ---------------
    -- BIT PRODUCTS
    ---------------
    subnet_a: for j in 0 to SIZE-1 generate
        subnet_b: for i in 0 to SIZE-1 generate
            bp(i,j) <= a(i) and b(j);
        end generate subnet_b;
    end generate subnet_a;

    ----------------
    -- INPUT STREAMS
    ----------------

    --subnet_fifo_A: for j in 2*SIZE-1 downto SIZE generate

    --    -- the value of i is 2*SIZE-1 <=> NN1

    --    fifo_stream_mn: entity fifostream
            
    --        generic map(
    --            -- fifo length (i+j)
    --            NN1+j)
            
    --        port map(
    --            -- sync signals
    --            r, t,
    --            -- bit product a(n) & b(m)
    --            bp( n(NN1, j),              -- n(i, j)
    --                m(NN1, j)),             -- m(i, j)
    --            -- reference signal (n, m)
    --            pp( n(NN1, j),              -- n(i, j)
    --                m(NN1, j))              -- m(i, j)
    --                (NN1+j downto 0));      -- i+j:0:-1

    --end generate subnet_fifo_A;

    --subnet_fifo_B: for j in N1 downto 0 generate
    --    fifo_stream_mn: entity fifostream
    --        generic (NN1+j) -- fifo length (i+j)
    --        port map (r, t, -- sync signals
    --            pi( -- bit product a(n) & b(m)
    --                n(NN1, j),
    --                m(NN1, j)),
    --            pp( -- reference signal n, m, k
    --                n(NN1, j),
    --                m(NN1, j),
    --                NN1+j));
    --end generate subnet_fifo_B;

    --subnet_fifo_j: for j in 0 to SIZE-1 generate
    --    subnet_fifo_i: for i in 0 to SIZE-1 generate
    --    fifo_stream_mn: entity fifostream
    --        generic (NN1+j) -- fifo length (i+j)
    --        port map (r, t, -- sync signals
    --            pi( -- bit product a(n) & b(m)
    --                n(NN1, j),
    --                m(NN1, j)),
    --            pp( -- reference signal n, m, k
    --                n(NN1, j),
    --                m(NN1, j),
    --                NN1+j));
    --    end generate subnet_fifo_i;
    --end generate subnet_fifo_j;

    ------------------------------
    ---- TOP-RIGHT CELL (i=0, j=0)
    ------------------------------

    ---- instantiate input fifo buffer:
    --fifo_in_00: entity fifobuf
    --    generic map(0+0)            -- fifo length
    --    port map(r, t,              -- sync signals
    --        pi(n(0,0), m(0,0)),     -- input product a(n) & b(m)
    --        db(0,0));               -- output to cell 0,0

    ---- instantiate sync adder
    --async_00: entity addsync
    --    port map(r, t,              -- sync signals
    --        '0',                    -- input data A has no cell above
    --        db(0,0),                -- input data B from input buffer
    --        '0',                    -- carry in has no cell on the right
    --        do(0,0),                -- data  out
    --        co(0,0));               -- carry out

    ---- instantiate output fifo buffer
    --fifo_out_00: entity fifobuf
    --    generic map(2*(7-0))
    --    port map(r, t,              -- sync signals
    --        do(0,0),                -- input from last cell
    --        p(0));                  -- output to port

    -------------------
    ---- TOP LINE (j=0)
    -------------------
    --subnet_i0: for i in 1 to 7 generate

    --    -- instantiate input fifo buffer:
    --    fifo_in_i0: entity fifobuf
    --        generic map(i+0)        -- fifo length
    --        port map(r, t,          -- sync signals
    --            pi(n(i,0), m(i,0)), -- input product a(n) & b(m)
    --            db(i,0));           -- output to cell i,0

    --    -- instantiate sync adder
    --    async_i0: entity addsync
    --        port map(r, t,          -- sync signals
    --            '0',                -- input data A has no cell above
    --            db(i,0),            -- input data B from input buffer
    --            co(i-1,0),          -- carry in from cell on the right
    --            do(i,0),            -- data  out
    --            co(i,0));           -- carry out

    --end generate subnet_i0;

    -------------------------
    ---- UPPER TRIANGLE (i>j)
    -------------------------
    --subnet_j: for j in 1 to 7 generate
    --subnet_i: for i in 1 to 7 generate
    --upper_triangle: if i > j generate

    --    -- instantiate input fifo buffer:
    --    fifo_in_ij: entity fifobuf
    --        generic map(i+j)        -- fifo length
    --        port map(r, t,          -- sync signals
    --            pi(n(i,j), m(i,j)), -- input product a(n) & b(m)
    --            db(i,j));           -- output to cell i,j

    --    -- instantiate sync adder
    --    async_ij: entity addsync
    --        port map(r, t,  -- sync signals
    --            do(i, j-1), -- input data A from cell above
    --            db(i, j),   -- input data B from input buffer
    --            co(i-1, j), -- carry in from cell on the right
    --            do(i, j),   -- data  out
    --            co(i, j));  -- carry out

    --end generate upper_triangle;
    --end generate subnet_i;
    --end generate subnet_j;

    ----------------------
    ---- DIAGONALE (i = j)
    ----------------------
    --subnet_k: for k in 1 to 7 generate

    --    -- instantiate input fifo buffer:
    --    fifo_in_kk: entity fifobuf
    --        generic map(k+k)        -- fifo length
    --        port map(r, t,          -- sync signals
    --            pi(n(k,k), m(k,k)), -- input product a(n) & b(m)
    --            db(k,k));           -- output to cell k,k

    --    -- instantiate sync adder
    --    async_kk: entity addsync
    --        port map(r, t,  -- sync signals
    --            do(k, k-1), -- input data A from cell above
    --            db(k, k),   -- input data B from input buffer
    --            '0',        -- carry has no cell on the right
    --            do(k, k),   -- data  out
    --            co(k, k));  -- carry out

    --    -- instantiate output fifo buffer
    --    fifo_out_kk: entity fifobuf
    --        generic map(2*(7-k))
    --        port map(r, t,  -- sync signals
    --            do(k,k),    -- input from last cell
    --            p(k));      -- output to port

    --end generate subnet_k;

end architecture plpr_arch;

-------------------------------------------------
