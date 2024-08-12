-------------------------------------------------------------------------------

-- file: fifostream.vhdl
-- content: first-in first-out stream 1 bit width
-- Created: 2024 august 12
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size is any positive integer
-- size = 0 means that the pipe is a single wire      (index   0)
-- size = 1 means that the pipe is a single flip-flop (indices 0, 1)
-- size = N means a linked chain of N flip-flops      (indices 0, 1, etc...)

-------------
library ieee;
use ieee.std_logic_1164.all;

--------------------
entity fifostream is
    generic (size : integer := 0);  -- buffer size
    port (r : in  std_logic;        -- reset (active low)
          t : in  std_logic;        -- trigger (rising edge)
          i : in  std_logic;        -- data in
          -- output just the full buffer vector
          b : out std_logic_vector(size downto 0));
end entity fifostream;

---------------------------------------------
architecture fifostream_arch of fifostream is

    -- internal buffer
    signal bf: std_logic_vector(size downto 0);

begin

    -- the least significant bit (LSB)
    -- is always a copy of the input port
    bf(0) <= i;

    -- the full buffer is available at any time
    b <= bf;
    
    -----------------------------
    -- case N = 0
    -----------------------------

    -- the LSB is also the MSB,
    -- no extra hardware to generate

    -----------------------------
    -- case N > 0:
    -----------------------------

    NGATES : if size > 0 generate


    begin

        -- sequential logic
        process(r, t)
        begin
        
            -- asynchronous reset
            if r = '0' then
                
                -- clear internal buffer
                bf(size downto 1) <= (others => '0');

            -- synchronous shift
            elsif rising_edge(t) then
                
                -- shift buffer bits (low -> high)
                --for n in 0 to size-1 loop
                --    bf(n+1) <= bf(n);
                --end loop;

                bf(4) <= bf(3);
                bf(3) <= bf(2);
                bf(2) <= bf(1);
                bf(1) <= bf(0);
                
            end if;

        end process;

    end generate NGATES;

end architecture fifostream_arch;

-------------------------------------------------------------------------------
