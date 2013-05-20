library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HexToSevenSegment is
port( hexIn : in std_logic_vector(3 downto 0);
		segmentCode : out std_logic_vector(7 downto 0)
		);
end HexToSevenSegment;

architecture Behavioral of HexToSevenSegment is

begin
	with hexIn select
	segmentCode <= "11000000" when "0000",
						"11111001" when "0001",
						"10100100" when "0010",
						"10110000" when "0011",
						"10011001" when "0100",
						"10010010" when "0101",
						"10000010" when "0110",
						"11111000" when "0111",
						"10000000" when "1000",
						"10011000" when "1001",
						"10001000" when "1010",
						"10000011" when "1011",
						"11000110" when "1100",
						"10100001" when "1101",
						"10000110" when "1110",
						"10001110" when "1111",
						"XXXXXXXX" when others;
end Behavioral;

