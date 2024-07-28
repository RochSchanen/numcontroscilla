---------------------------------------------------------------------

-- file: fifobuf.vhd
-- content: first-in first-out buffer 1 bit size
-- Created: 2020 august 14
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size is any positive integer
-- size = 0 means that the pipe is a single wire
-- size = 1 means that the pipe is a single flip-flop
-- size = N means a linked chain of N flip-flops

---------------------------------------------------------------------

-------------------------------------------------
--                FIFOBUF
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity fifobuf is
    generic (size : integer := 0);  -- buffer size
    port (r : in  std_logic;        -- reset (active low)
          t : in  std_logic;        -- trigger (rising edge)
          i : in  std_logic;        -- data in
          o : out std_logic);       -- data out
end entity fifobuf;

-------------------------------------------------

architecture fifobuf_arch of fifobuf is
begin
    
    -- case N = 0:
    NOGATE : if size = 0 generate

    begin

        -- create a direct input-to-output link
        o <= i;

    end generate NOGATE;

    -- case N > 0:
    NGATES : if size > 0 generate

        -- buffer
        signal bf: std_logic_vector(size-1 downto 0);

    begin
        
        -- output most significant bit (MSB)
        o <= bf(size-1);

        -- sequential logic
        process(r, t)
        begin
        
            -- asynchronous reset
            if r = '0' then
                
                -- clear buffer
                bf <= (others => '0');

            -- synchronous shift
            elsif rising_edge(t) then
                
                -- shift (see note 1)
                for n in size-1 downto 1 loop
                    bf(n) <= bf(n-1);
                end loop;
                
                -- load least significant bit (LSB)
                bf(0) <= i;

            end if;

        end process;

    end generate NGATES;

-- done
end architecture fifobuf_arch;

-------------------------------------------------

-- note 1: intentionally, the shift loop does not generate
-- any logic when the generic size is equal to 1. in this
-- case, the buffer is  exactly bf(0). it has a size of 1.
-- it has input "i" and output "o".