-------------------------------------------------------------------------------
-- file: fifostream.vhdl
-- content: first-in first-out stream 1 bit width
-- Created: 2024 august 12
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size is any positive integer
-- size = 0 means that the pipe is a single wire (1 index: 0)
-- size = 1 means that the pipe is a single flip-flop (2 indices: 0 and 1)
-- size = N means a linked chain of N flip-flops (N+1 indices 0, 1, up to N)
-- the ouput o(0) is a straight unbuffered copy of the input bit i
-- the other output form a copy of the buffered stream.

-------------
library ieee;
use ieee.std_logic_1164.all;

entity fifostream is
    generic (size : integer := 0);  -- buffer size
    port (r : in  std_logic;        -- reset (active low)
          t : in  std_logic;        -- trigger (rising edge)
          i : in  std_logic;        -- data in
          o : out std_logic_vector(size downto 0)); -- data out
end entity fifostream;

---------------------------------------------
architecture fifostream_arch of fifostream is
begin

    ---- always forward input bit to ouput port-0
    o(0) <= i;

    -- case N > 0:
    NGATES : if size > 0 generate

        -- buffer
        signal bf: std_logic_vector(size-1 downto 0);

    begin

        -- sequential logic
        process(r, t)
        begin

            -- asynchronous reset
            if r = '0' then

                -- clear buffer
                bf(size-1 downto 0) <= (others => '0');

            -- synchronous shift
            elsif rising_edge(t) then

                -- shift internal flip-flops
                for n in size-1 downto 1 loop
                    bf(n) <= bf(n-1);
                end loop;

                -- first flip-flop
                bf(0) <= i;

            end if;

        -- done
        end process;

        -- output buffered stream to port
        o(size downto 1) <= bf;

    -- done
    end generate NGATES;

-- done
end architecture fifostream_arch;

-------------------------------------------------------------------------------