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
    do <= 	"0000000000000" WHEN "0000000000", --Nop
				"0000000000000" WHEN "0000000001", --Nop
				"0001100001111" WHEN "0000000010", --load 0x0F into r0
				"0010000000010" WHEN "0000000011", --load 0x20 into r0
				"0001100010100" WHEN "0000000100", --load 0x04 into r1
				"0010000010001" WHEN "0000000101", --load 0x10 into r1
				"0000000000000" WHEN "0000000110", --Nop
				"0000100000001" WHEN "0000000111", --add r1 and r0 into r0
				"0001100010100" WHEN "0000001000", --load 0x04 into r1
				"0010000010000" WHEN "0000001001", --load 0x00 into r1
				"0001000000001" WHEN "0000001010", --subtract r1 and r0 into r0
				"0000000000000" WHEN OTHERS; --Nop forever
end behavioural;

