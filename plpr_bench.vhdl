---------------------------------------------------------------------

-- file: plpr_bench.vhd
-- content: bench to simulate plpr code
-- created: 2024 august 4
-- author: roch schanen
-- comments:

---------------------------------------------------------------------

-------------------------------------------------
--          PIPELINED PRODUCT BENCH
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use ieee.std_logic_textio.all;
use std.textio.all;

library work;
use work.all;

-------------------------------------------------

entity plpr_bench is
end plpr_bench;

-------------------------------------------------

architecture plpr_bench_arch of plpr_bench is

    -- configuration

    constant SIZE : integer := 16;

    -- signals
    signal r : std_logic;                           -- bench reset
    signal t : std_logic;                           -- bench clock
    signal c : std_logic_vector(2*SIZE-1 downto 0); -- bench counter
    signal a : std_logic_vector(SIZE-1 downto 0);   -- plpr input A
    signal b : std_logic_vector(SIZE-1 downto 0);   -- plpr input B
    signal q : std_logic_vector(2*SIZE-1 downto 0); -- plpr output

    -- display function (variable size logic vector)
    function to_string(v :std_logic_vector)
        return string is variable s : string(v'length downto 1);
    begin
        for i in v'range loop
            if v(i) = '1' then
                s(i+1) := '1';
            else
                s(i+1) := '0';
            end if;
        end loop;
        return s;
    end function;

    -- file
    file fh : text open write_mode is ".outputs/bench.txt";
    
begin

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200mhz
        port map(t);        -- t: clock signal

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(3 ns)   -- duration
        port map(r);        -- r: reset signal

    ---- instanciate bench counter
    --bench_counter_1: entity benchcounter
    --    generic map(2*SIZE) -- counter size
    --    port map(r, t, c);  -- a: counter output

    -- extract counter subsets
    --a <= c(SIZE-1 downto 0);
    --b <= c(2*SIZE-1 downto SIZE);
    a <= "0110010101001010";
    b <= "0100101010001010";

    -- instanciate pipelined nco
    pl_pr_1: entity plpr
        generic map(SIZE)
        port map(r, t, a, b, q);    -- scan through all

     -- file out: header
    process
        variable l : line;
    begin
        write(l, string'("plpr"));
        write(l, string'(" size="));
        write(l, integer'(SIZE));
        write(l, string'(" latency="));
        write(l, integer'(4*SIZE));
        writeline(fh, l);
        wait;
    end process;

     -- file out: synchronised
    process(r, t) is
        variable l : line;
    begin
        if rising_edge(t) then
            write(l, to_string(a));
            write(l, string'(" "));
            write(l, to_string(b));
            write(l, string'(" "));
            write(l, to_string(q));
            writeline(fh, l);
        end if;
    end process;

end plpr_bench_arch;

-------------------------------------------------
