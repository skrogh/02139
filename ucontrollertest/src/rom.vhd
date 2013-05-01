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
do <= "0110000000000" WHEN "0000000000",
"0110110010000" WHEN "0000000001",
"0111000000111" WHEN "0000000010",
"0110110000000" WHEN "0000000011",
"0111000001011" WHEN "0000000100",
"0110110000000" WHEN "0000000101",
"0111000001101" WHEN "0000000110",
"0110110000000" WHEN "0000000111",
"0111000001110" WHEN "0000001000",
"0110110000000" WHEN "0000001001",
"0011100000000" WHEN "0000001010",
"0000000000000" when others;
end behavioural;
