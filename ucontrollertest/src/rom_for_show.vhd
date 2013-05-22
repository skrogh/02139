library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity rom is
port( clk : in std_logic;
addr : in std_logic_vector( 9 downto 0 );
do : out std_logic_vector( 12 downto 0 ) );
end rom;
architecture behavioural of rom is
signal addr_clkd : std_logic_vector( 9 downto 0 );
begin
process( CLK ) begin
if rising_edge( CLK ) then
addr_clkd <= addr;
end if;
end process;
with addr_clkd select
do <=
--A lot of binary code follows, this is not shown,
--but can be found on github
"0000000000000" when others;
end behavioural;
