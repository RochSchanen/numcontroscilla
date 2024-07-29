---------------------------------------------------------------------

-- file: benchrom.vhdl
-- content: simulated read only memory
-- Created: 2024 July 29
-- Author: Roch Schanen
-- comments:
-- data loaded from a file at initialisation.
-- output data are applied when output enabled is high.
-- otherwise the output lines remain at high impedance.
-- the data file contains (2**AL) lines.
-- one line contains DW bits.

---------------------------------------------------------------------

-------------------------------------------------
--                BENCH ROM
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use STD.textio.all;

-------------------------------------------------

entity benchrom is

    -- rom geometry (configuration)
    generic (
        FN : string  := "SIN256x8.txt";             -- file name
        AL : integer := 8;                          -- address length
        DW : integer := 8);                         -- data width

    -- ports
    port (
        a : in std_logic_vector (AL-1 downto 0);    -- address in
        e : in std_logic;                           -- output enable
        o : out std_logic_vector (DW-1 downto 0));  -- data out

-- done
end entity benchrom;

-------------------------------------------------

architecture benchrom_arch of benchrom is

    -- define geometry (build core type)
    type CORE is array (0 to 2**AL-1) 
        of std_logic_vector(DW-1 downto 0);

    -- init rom from file function

    ----------------------

    impure function initRom(f: in string) return CORE is 

        -- local variables
        file     h : text is in f;
        variable l : line;
        variable c : CORE;

    begin

        -- load data from each lines
        for i in 0 to 2**AL-1 loop
            readline (h, l);  -- get line
            read (l, c(i));   -- convert line to data
        end loop;

        -- data ready
        return c;
    
    end function initRom;
    
    -- instantiate rom using init function
    constant c : CORE := initRom(FN);

    ----------------------

begin

    -- sequential logic
    process (a, e)

    begin

        -- enable output
        if e = '1' then

            -- load data
            o <= c(to_integer(unsigned(a)));

        -- high impedance output
        else
            o <= (others => 'Z');

        end if;

    end process;

--done
end architecture benchrom_arch;
