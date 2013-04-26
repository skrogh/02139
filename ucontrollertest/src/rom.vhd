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
    do <= 	"0001100000100" when "0000000000",	--sln r0 4
				"0010000000111" when "0000000001",	--shn r0 7
				"0001100010010" when "0000000010",	--sln r1 2
				"0010000010011" when "0000000011",	--shn r1 3
				"0000100010000" when "0000000100",	--add r1 r0
				"0011000000001" when "0000000101",	--mov r0 r1
				"0000000000000" when "0000000110",	--nop 0
				"0000000000000" when "0000000111",	--nop 0
				"0000000000000" when "0000001000",	--nop 0
				"0000000000000" when "0000001001",	--nop 0
				"0000000000000" when "0000001010",	--nop 0
				"0000000000000" when "0000001011",	--nop 0
				"0000000000000" when "0000001100",	--nop 0
				"0011100000000" when "0000001101",	--jmpa 0
				"0000000000000" WHEN OTHERS; --Nop forever
end behavioural;

