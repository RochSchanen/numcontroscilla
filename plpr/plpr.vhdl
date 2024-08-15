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
    constant N1  : integer := SIZE-1;
    constant NN1 : integer := 2*SIZE-1;

    ---------------------------------------------------------------
    type type_1 is array (0 to N1,  0 to N1) of std_logic;
    type type_2 is array (0 to NN1, 0 to NN1) of std_logic;
    type type_3 is array (0 to N1,  0 to N1) of std_logic_vector(2*NN1 downto 0);

    ------------------
    signal bp: type_1;
    signal so, co: type_2;
    signal fsa: type_3;

    -----------------------------------------------------------------
    -- returns the n index of bit product from the cell position i, j
    function n(i: integer; j: integer) return integer is    
        variable x: integer;
    begin
        if j > N1 then x := N1; else x := j; end if;
        return x;
    end function;

    --------------------------------------------
    -- returns the m index of bit product from the cell position i, j
    function m(i: integer; j: integer) return integer is    
        variable x: integer;
    begin
        if i-j < SIZE then x := i-j; else x := N1; end if;
        return x;
    end function;

begin

    ---------------
    -- BIT PRODUCTS
    ---------------
    subnet_a: for j in 0 to N1 generate
        subnet_b: for i in 0 to N1 generate
            bp(i,j) <= a(i) and b(j);
        end generate subnet_b;
    end generate subnet_a;

    ------------------
    -- INPUT STREAMS A
    ------------------
    subnet_fifo_A: for j in NN1 downto SIZE generate
        fifo_stream_mn: entity fifostream
            generic map(NN1+j)
            port map(r, t, bp(n(NN1, j), m(NN1, j)), fsa(n(NN1, j), m(NN1, j))(NN1+j downto 0));
    end generate subnet_fifo_A;

    ------------------
    -- INPUT STREAMS B
    ------------------
    subnet_fifo_B: for j in N1 downto 0 generate
        fifo_stream_mn: entity fifostream
            generic map(NN1+j)
            port map(r, t, bp(n(NN1, j), m(NN1, j)), fsa(n(NN1, j), m(NN1, j))(NN1+j downto 0));
    end generate subnet_fifo_B;

    ---------------------
    -- INPUT STREAMS I, J
    ---------------------
    subnet_fifo_j: for j in 0 to N1-1 generate
        subnet_fifo_i: for i in j to j+N1-1 generate
        fifo_stream_mn: entity fifostream
            generic map(i+j)
            port map(r, t, bp(n(i, j), m(i, j)), fsa(n(i, j), m(i, j))(i+j downto 0));
        end generate subnet_fifo_i;
    end generate subnet_fifo_j;

    ----------------------------
    -- TOP-RIGHT CELL (i=0, j=0)
    ----------------------------
    async_00: entity addsync
        port map(r, t, '0', fsa(0,0)(0), '0', so(0,0), co(0,0));
    fifo_out_00: entity fifobuf
        generic map(2*(NN1-0))
        port map(r, t, so(0,0), p(0));

    -----------------
    -- TOP LINE (j=0)
    -----------------
    subnet_i0: for i in 1 to NN1 generate
        async_i0: entity addsync
            port map(r, t, '0', fsa(n(i, 0), m(i, 0))(i+0), co(i-1, 0), so(i, 0), co(i, 0));
    end generate subnet_i0;

    -----------------------
    -- UPPER TRIANGLE (i>j)
    -----------------------
    subnet_j: for j in 1 to NN1 generate
        subnet_i: for i in 1 to NN1 generate
            upper_triangle: if i > j generate
                async_ij: entity addsync
                    port map(r, t, so(i, j-1), fsa(n(i, j), m(i, j))(i+j), co(i-1, j), so(i, j), co(i, j));
            end generate upper_triangle;
        end generate subnet_i;
    end generate subnet_j;

    --------------------
    -- DIAGONALE (i = j)
    --------------------
    subnet_k: for k in 1 to NN1 generate
        async_kk: entity addsync
            port map(r, t, so(k, k-1), fsa(n(k, k), m(k, k))(k+k), '0', so(k, k), co(k, k));
        fifo_out_kk: entity fifobuf
            generic map(2*(NN1-k))
            port map(r, t, so(k,k), p(k));
    end generate subnet_k;

end architecture plpr_arch;

-------------------------------------------------
