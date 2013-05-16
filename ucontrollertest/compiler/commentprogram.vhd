library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity rom is
port( addr : in std_logic_vector( 9 downto 0 );
do : out std_logic_vector( 12 downto 0 ) );
end rom;
architecture behavioural of rom is
begin
with addr select
do <= "0000000000000" when others;
end behavioural;
