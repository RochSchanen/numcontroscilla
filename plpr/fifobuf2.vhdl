-- ########################################################

-- file: fifobuf2.vhdl
-- content: first-in first-out buffer 1 bit size
-- Created: 2024 august 10
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size is any positive integer
-- size = 0 means that the pipe is a single wire
-- size = 1 means that the pipe is a single flip-flop
-- size = N means a linked chain of N flip-flops

-- ########################################################

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity fifobuf2 is
    generic (size : integer := 0);  -- buffer size
    port (r : in  std_logic;        -- reset (active low)
          t : in  std_logic;        -- trigger (rising edge)
          i : in  std_logic;        -- data in
          o : out std_logic;        -- data out
          b : out std_logic_vector(size downto 0)); -- full buffer access
end entity fifobuf2;

-------------------------------------------------

architecture fifobuf2_arch of fifobuf2 is

begin

    -- the least significant bit (LSB)
    -- is always a copy of the input port
    b(0) <= i;
    
    -- the output port is always a copy
    -- of the most significant bit (MSB)
    o <= bf(size);

    -- case N = 0: the LSB is also the MSB,
    -- no extra hardware to generate

    -- case N > 0:
    NGATES : if size > 0 generate

        -- buffer
        signal bf: std_logic_vector(size downto 0);

    begin

        -- output full buffer
        b(size downto 1) <= bf(size downto 1);

        -- sequential logic
        process(r, t)
        begin
        
            -- asynchronous reset
            if r = '0' then
                
                -- clear buffer
                bf <= (others => '0');

            -- synchronous shift
            elsif rising_edge(t) then
                
                -- shift
                for n in size downto 1 loop
                    bf(n) <= bf(n-1);
                end loop;
                
            end if;

        end process;

    end generate NGATES;

-- done
end architecture fifobuf2_arch;

-------------------------------------------------
