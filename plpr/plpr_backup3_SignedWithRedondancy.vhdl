--------------------------------------------------------------------------------
-- file: plpr.vhdl
-- content: pipelined signed product
-- created: 2024 august 10
-- author: roch schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size has been tested for integers larger than 4 <- only 4 so far
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
    generic (size : integer := 4);                      -- factors size
    port (r : in  std_logic;                            -- reset (active low)
          t : in  std_logic;                            -- trigger (rising edge)
          a : in  std_logic_vector(size-1 downto 0);    -- input a (4 bits)
          b : in  std_logic_vector(size-1 downto 0);    -- input b (4 bits)
          p : out std_logic_vector(2*size-1 downto 0)); -- product ab (8 bits)
end entity plpr;

---------------------------------
architecture plpr_arch of plpr is

    -------------------------------------------------------------
    type type_1 is array (0 to size-1, 0 to size-1) of std_logic;
    type type_2 is array (0 to 2*size-1, 0 to 2*size-1) of std_logic;

    ----------------------------------
    -- connections to the bit products
    -- (the full square is used)
    signal pi: type_1;

    ---------------------------------------
    -- connections to the add-sync entities
    -- (only top-left triangle plus diagonal are used)
    signal db, do, co: type_2;

    -----------------------------------------
    -- data bit row n from cell position i, j
    function n(i: integer; j: integer) return integer is    
        variable x: integer;
    begin
        if j > 3 then x := 3; else x := j; end if;
        return x;
    end function;

    --------------------------------------------
    -- data bit column m from cell position i, j
    function m(i: integer; j: integer) return integer is    
        variable x: integer;
    begin
        if i-j < size then x := i-j; else x := 3; end if;
        return x;
    end function;

begin

--------------------------
-- INSTANCIATE NETWORKS --
--------------------------

    ---------------
    -- BIT PRODUCTS
    ---------------
    subnet_a: for j in 0 to size-1 generate
        subnet_b: for i in 0 to size-1 generate
            pi(i,j) <= a(i) and b(j);
        end generate;
    end generate;

    ----------------------------
    -- TOP-RIGHT CELL (i=0, j=0)
    ----------------------------

    -- instantiate input fifo buffer:
    fifo_in_00: entity fifobuf
        generic map(0+0)        -- fifo length
        port map(r, t,          -- sync signals
            pi(n(0,0), m(0,0)), -- input product a(n) & b(m)
            db(0,0));           -- output to cell 0,0

    -- instantiate sync adder
    async_00: entity addsync
        port map(r, t,  -- sync signals
            '0',        -- input data A has no cell above
            db(0,0),    -- input data B from input buffer
            '0',        -- carry in has no cell on the right
            do(0,0),    -- data  out
            co(0,0));   -- carry out

    -- instantiate output fifo buffer
    fifo_out_00: entity fifobuf
        generic map(2*(7-0))
        port map(r, t,  -- sync signals
            do(0,0),    -- input from last cell
            p(0));      -- output to port

    -----------------
    -- TOP LINE (j=0)
    -----------------
    subnet_i0: for i in 1 to 7 generate

        -- instantiate input fifo buffer:
        fifo_in_i0: entity fifobuf
            generic map(i+0)        -- fifo length
            port map(r, t,          -- sync signals
                pi(n(i,0), m(i,0)), -- input product a(n) & b(m)
                db(i,0));           -- output to cell i,0

        -- instantiate sync adder
        async_i0: entity addsync
            port map(r, t,  -- sync signals
                '0',        -- input data A has no cell above
                db(i,0),    -- input data B from input buffer
                co(i-1,0),  -- carry in from cell on the right
                do(i,0),    -- data  out
                co(i,0));   -- carry out

    end generate subnet_i0;

    -----------------------
    -- UPPER TRIANGLE (i>j)
    -----------------------
    subnet_j: for j in 1 to 7 generate
        subnet_i: for i in 1 to 7 generate
            upper_triangle: if i > j generate

                -- instantiate input fifo buffer:
                fifo_in_ij: entity fifobuf
                    generic map(i+j)        -- fifo length
                    port map(r, t,          -- sync signals
                        pi(n(i,j), m(i,j)), -- input product a(n) & b(m)
                        db(i,j));           -- output to cell i,j

                -- instantiate sync adder
                async_ij: entity addsync
                    port map(r, t,  -- sync signals
                        do(i, j-1), -- input data A from cell above
                        db(i, j),   -- input data B from input buffer
                        co(i-1, j), -- carry in from cell on the right
                        do(i, j),   -- data  out
                        co(i, j));  -- carry out

            end generate upper_triangle;
        end generate subnet_i;
    end generate subnet_j;

    --------------------
    -- DIAGONALE (i = j)
    --------------------
    subnet_k: for k in 1 to 7 generate

        -- instantiate input fifo buffer:
        fifo_in_kk: entity fifobuf
            generic map(k+k)        -- fifo length
            port map(r, t,          -- sync signals
                pi(n(k,k), m(k,k)), -- input product a(n) & b(m)
                db(k,k));           -- output to cell k,k

        -- instantiate sync adder
        async_kk: entity addsync
            port map(r, t,  -- sync signals
                do(k, k-1), -- input data A from cell above
                db(k, k),   -- input data B from input buffer
                '0',        -- carry has no cell on the right
                do(k, k),   -- data  out
                co(k, k));  -- carry out

        -- instantiate output fifo buffer
        fifo_out_kk: entity fifobuf
            generic map(2*(7-k))
            port map(r, t,  -- sync signals
                do(k,k),    -- input from last cell
                p(k));      -- output to port

    end generate subnet_k;

end architecture plpr_arch;

-------------------------------------------------
