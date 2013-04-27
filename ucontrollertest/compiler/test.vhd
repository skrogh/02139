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
do <= "0001100001111" WHEN "0000000000",
"0010000001111" WHEN "0000000001",
"0001100100001" WHEN "0000000010",
"0010000100000" WHEN "0000000011",
"0011000010000" WHEN "0000000100",
"0001000100010" WHEN "0000000101",
"0101000000011" WHEN "0000000110",
"0001000100010" WHEN "0000000111",
"0011100000100" WHEN "0000001000",
"0001100101010" WHEN "0000001001",
"0010000101010" WHEN "0000001010",
"000000000000" when others;
end behavioural;
