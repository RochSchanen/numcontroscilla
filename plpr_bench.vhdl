---------------------------------------------------------------------

-- file: plpr_bench.vhd
-- content: bench to simulate plpr code
-- Created: 2024 August 4
-- Author: Roch Schanen
-- comments:

---------------------------------------------------------------------

-------------------------------------------------
--          PIPELINED PRODUCT BENCH
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.all;

-------------------------------------------------

entity plpr_bench is
end plpr_bench;

-------------------------------------------------

architecture plpr_bench_arch of plpr_bench is

    -- configuration

    constant SIZE : integer := 4;

    -- signals
    signal r : std_logic;                           -- bench reset
    signal t : std_logic;                           -- bench clock
    signal c : std_logic_vector(2*SIZE-1 downto 0); -- bench counter
    signal a : std_logic_vector(SIZE-1 downto 0);
    signal b : std_logic_vector(SIZE-1 downto 0);

    signal q : std_logic_vector(2*SIZE-1 downto 0); -- plpr output

    function to_string(v : std_logic_vector) return string is
        variable s : string(v'length downto 1);
    begin
        for i in v'range loop
            if v(i) = '1' then
                --s(v'length - i) := '1';
                s(i+1) := '1';
            else
                --s(v'length - i) := '0';
                s(i+1) := '0';
            end if;
        end loop;
        return s;
    end function;

begin

    -- instanciate bench clock
    bench_clock_1: entity benchclock
        generic map(2.5 ns) -- 200MHz
        port map(t);        -- t: clock signal

    -- instanciate bench reset
    bench_reset_1: entity benchreset
        generic map(3 ns)   -- duration
        port map(r);        -- r: reset signal

    -- instanciate bench counter
    bench_counter_1: entity benchcounter
        generic map(2*SIZE) -- counter size
        port map(r, t, c);  -- a: counter output

    -- extract subsets
    a <= c(3 downto 0);
    b <= c(7 downto 4);

    -- instanciate pipelined nco
    pl_pr_1: entity plpr
        generic map(SIZE)
        port map(r, t, a, b, q);    -- scan through all

    process(r, t) is
    begin
        if rising_edge(t) then
            report to_string(a) & "x" & to_string(b) & "=" & to_string(q) ;
        end if;
    end process;

end plpr_bench_arch;

-------------------------------------------------
