library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port(   addr : in std_logic_vector( 9 downto 0 );
            do : out std_logic_vector( 12 downto 0 ) );
end rom;

architecture behavioural of rom is
begin
    with addr select
	 --       ----|---|---|	
    do <= 	"0001100001111" when "0000000000",	--sln r0 15
"0010000001111" when "0000000001",	--shn r0 15
"0001100100001" when "0000000010",	--sln r2 1
"0010000100000" when "0000000011",	--shn r2 0
"0011000010000" when "0000000100",	--mov r1 r0
"0001000010010" when "0000000101",	--sub r1 r2
"0100000000011" when "0000000110",	--brnp 3
"0001000000010" when "0000000111",	--sub r0 r2
"0011100000100" when "0000001000",	--jmpa 4
"0001100101010" when "0000001001",	--sln r2 10
"0010000101010" when "0000001010",	--shn r2 10
				"0000000000000" WHEN OTHERS; --Nop forever, well... till overfow
end behavioural;

