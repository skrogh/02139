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
do <= "0111100000000" WHEN "0000000000",
"1000100000011" WHEN "0000000001",
"0111100000001" WHEN "0000000010",
"1000110011111" WHEN "0000000011",
"0111100000010" WHEN "0000000100",
"1000100100101" WHEN "0000000101",
"0111100000011" WHEN "0000000110",
"1000100001101" WHEN "0000000111",
"0111100000100" WHEN "0000001000",
"1000110011001" WHEN "0000001001",
"0111100000101" WHEN "0000001010",
"1000101001001" WHEN "0000001011",
"0111100000110" WHEN "0000001100",
"1000101000001" WHEN "0000001101",
"0111100000111" WHEN "0000001110",
"1000100011111" WHEN "0000001111",
"0111100001000" WHEN "0000010000",
"1000100000001" WHEN "0000010001",
"0111100001001" WHEN "0000010010",
"1000100011001" WHEN "0000010011",
"0111100001010" WHEN "0000010100",
"1000100010001" WHEN "0000010101",
"0111100001011" WHEN "0000010110",
"1000111000001" WHEN "0000010111",
"0111100001100" WHEN "0000011000",
"1000101100011" WHEN "0000011001",
"0111100001101" WHEN "0000011010",
"1000110000101" WHEN "0000011011",
"0111100001110" WHEN "0000011100",
"1000101100001" WHEN "0000011101",
"0111100001111" WHEN "0000011110",
"1000101110001" WHEN "0000011111",
"0111100010000" WHEN "0000100000",
"1000101000011" WHEN "0000100001",
"0111100010001" WHEN "0000100010",
"1000110010001" WHEN "0000100011",
"0111100010010" WHEN "0000100100",
"1000111110011" WHEN "0000100101",
"0111100010011" WHEN "0000100110",
"1000110000111" WHEN "0000100111",
"0111100010100" WHEN "0000101000",
"1000101010001" WHEN "0000101001",
"0111100010101" WHEN "0000101010",
"1000111100011" WHEN "0000101011",
"0111100010110" WHEN "0000101100",
"1000111010101" WHEN "0000101101",
"0111100010111" WHEN "0000101110",
"1000111010101" WHEN "0000101111",
"0111100011000" WHEN "0000110000",
"1000111000101" WHEN "0000110001",
"0111100011001" WHEN "0000110010",
"1000100110001" WHEN "0000110011",
"0111100011010" WHEN "0000110100",
"1000100101001" WHEN "0000110101",
"0111100011011" WHEN "0000110110",
"1000111110101" WHEN "0000110111",
"0111100011100" WHEN "0000111000",
"1000101001011" WHEN "0000111001",
"0111100011101" WHEN "0000111010",
"1000111100001" WHEN "0000111011",
"0111100011110" WHEN "0000111100",
"1000110000011" WHEN "0000111101",
"0111100011111" WHEN "0000111110",
"1000110101011" WHEN "0000111111",
"0111100100000" WHEN "0001000000",
"1000110000001" WHEN "0001000001",
"0111100100001" WHEN "0001000010",
"1000110010001" WHEN "0001000011",
"0111100100010" WHEN "0001000100",
"1000110001001" WHEN "0001000101",
"0111100100011" WHEN "0001000110",
"1000100100111" WHEN "0001000111",
"0111100100100" WHEN "0001001000",
"1000100100111" WHEN "0001001001",
"0111100100101" WHEN "0001001010",
"1000100001110" WHEN "0001001011",
"0111100100110" WHEN "0001001100",
"1000100010110" WHEN "0001001101",
"0111100100111" WHEN "0001001110",
"1000100011001" WHEN "0001001111",
"0111100101000" WHEN "0001010000",
"1000100011101" WHEN "0001010001",
"0111100101001" WHEN "0001010010",
"1000100100010" WHEN "0001010011",
"0111100101010" WHEN "0001010100",
"1000100100100" WHEN "0001010101",
"0111100101011" WHEN "0001010110",
"1000100001101" WHEN "0001010111",
"0111100101100" WHEN "0001011000",
"1000100010010" WHEN "0001011001",
"0111100101101" WHEN "0001011010",
"1000100011100" WHEN "0001011011",
"0111100101110" WHEN "0001011100",
"1000100011001" WHEN "0001011101",
"0111100101111" WHEN "0001011110",
"1000100001110" WHEN "0001011111",
"0111100110000" WHEN "0001100000",
"1000100010111" WHEN "0001100001",
"0111100110001" WHEN "0001100010",
"1000100011100" WHEN "0001100011",
"0111100110010" WHEN "0001100100",
"1000100001110" WHEN "0001100101",
"0111100110011" WHEN "0001100110",
"1000100100100" WHEN "0001100111",
"0111111111111" WHEN "0001101000",
"1000100000111" WHEN "0001101001",
"0111111111110" WHEN "0001101010",
"1000100010000" WHEN "0001101011",
"1011100010000" WHEN "0001101100",
"0111000000011" WHEN "0001101101",
"0000100010000" WHEN "0001101110",
"1100000100000" WHEN "0001101111",
"0111000001001" WHEN "0001110000",
"0000100010000" WHEN "0001110001",
"0010100000000" WHEN "0001110010",
"1010100100001" WHEN "0001110011",
"0111111111001" WHEN "0001110100",
"1001000100000" WHEN "0001110101",
"0111111111000" WHEN "0001110110",
"1001000010000" WHEN "0001110111",
"0111111111000" WHEN "0001111000",
"1011100010000" WHEN "0001111001",
"0111000000100" WHEN "0001111010",
"0000100010000" WHEN "0001111011",
"1001000010000" WHEN "0001111100",
"0111111111001" WHEN "0001111101",
"1011100010000" WHEN "0001111110",
"0111000000100" WHEN "0001111111",
"0000100010000" WHEN "0010000000",
"1001000010000" WHEN "0010000001",
"0111001101100" WHEN "0010000010",
"0011001110000" WHEN "0010000011",
"0111000000000" WHEN "0010000100",
"0000100000111" WHEN "0010000101",
"1000000000000" WHEN "0010000110",
"1001100100000" WHEN "0010000111",
"0010100000000" WHEN "0010001000",
"1011000000010" WHEN "0010001001",
"0101000000010" WHEN "0010001010",
"0100000000110" WHEN "0010001011",
"0111111111101" WHEN "0010001100",
"1001100100000" WHEN "0010001101",
"0111000000010" WHEN "0010001110",
"0000100100000" WHEN "0010001111",
"1001000100000" WHEN "0010010000",
"0111001101100" WHEN "0010010001",
"0011001110000" WHEN "0010010010",
"0111000000001" WHEN "0010010011",
"0000100000111" WHEN "0010010100",
"1000000000000" WHEN "0010010101",
"1001100100000" WHEN "0010010110",
"0010100000000" WHEN "0010010111",
"1011000000010" WHEN "0010011000",
"0101000000010" WHEN "0010011001",
"0100000000110" WHEN "0010011010",
"0111111111101" WHEN "0010011011",
"1001100100000" WHEN "0010011100",
"0111000000101" WHEN "0010011101",
"0000100100000" WHEN "0010011110",
"1001000100000" WHEN "0010011111",
"0111001101100" WHEN "0010100000",
"0011001110000" WHEN "0010100001",
"0111000000010" WHEN "0010100010",
"0000100000111" WHEN "0010100011",
"1000000000000" WHEN "0010100100",
"1001100100000" WHEN "0010100101",
"0010100000000" WHEN "0010100110",
"1011000000010" WHEN "0010100111",
"0101000000010" WHEN "0010101000",
"0100000010011" WHEN "0010101001",
"0111000000001" WHEN "0010101010",
"0011000010000" WHEN "0010101011",
"0111111111101" WHEN "0010101100",
"1001100000000" WHEN "0010101101",
"0111111111111" WHEN "0010101110",
"1001100100000" WHEN "0010101111",
"0111111111110" WHEN "0010110000",
"1001100110000" WHEN "0010110001",
"1011000000010" WHEN "0010110010",
"0101001100001" WHEN "0010110011",
"0001000110001" WHEN "0010110100",
"0101001110110" WHEN "0010110101",
"0001000000010" WHEN "0010110110",
"0111111111101" WHEN "0010110111",
"1001000000000" WHEN "0010111000",
"0111111111110" WHEN "0010111001",
"1001000110000" WHEN "0010111010",
"0100000011001" WHEN "0010111011",
"0111000000001" WHEN "0010111100",
"0011000010000" WHEN "0010111101",
"0111111111101" WHEN "0010111110",
"1001101000000" WHEN "0010111111",
"0111011111111" WHEN "0011000000",
"0010111000000" WHEN "0011000001",
"0011011010000" WHEN "0011000010",
"0011011100000" WHEN "0011000011",
"0011011110000" WHEN "0011000100",
"0011001010100" WHEN "0011000101",
"0111001100100" WHEN "0011000110",
"0000111010001" WHEN "0011000111",
"0001001010000" WHEN "0011001000",
"0101000000010" WHEN "0011001001",
"0100100000011" WHEN "0011001010",
"0000101010000" WHEN "0011001011",
"0111000001010" WHEN "0011001100",
"0000111100001" WHEN "0011001101",
"0001001010000" WHEN "0011001110",
"0101000000010" WHEN "0011001111",
"0100100000011" WHEN "0011010000",
"0000101010000" WHEN "0011010001",
"0011011110101" WHEN "0011010010",
"0100001100101" WHEN "0011010011",
"0111111111001" WHEN "0011010100",
"1100000010000" WHEN "0011010101",
"0111000001001" WHEN "0011010110",
"0000100010000" WHEN "0011010111",
"1001000010000" WHEN "0011011000",
"0111111111000" WHEN "0011011001",
"1011100010000" WHEN "0011011010",
"0111000000100" WHEN "0011011011",
"0000100010000" WHEN "0011011100",
"1001000010000" WHEN "0011011101",
"0111001100100" WHEN "0011011110",
"0011001110000" WHEN "0011011111",
"0111000000010" WHEN "0011100000",
"0000100000111" WHEN "0011100001",
"1000000000000" WHEN "0011100010",
"1001100100000" WHEN "0011100011",
"0010100000000" WHEN "0011100100",
"1011000000010" WHEN "0011100101",
"0101000000010" WHEN "0011100110",
"0100101111011" WHEN "0011100111",
"0111000000001" WHEN "0011101000",
"0011000010000" WHEN "0011101001",
"0111111110111" WHEN "0011101010",
"1001100100000" WHEN "0011101011",
"0111111111010" WHEN "0011101100",
"1001100110000" WHEN "0011101101",
"0010100000000" WHEN "0011101110",
"1011000000011" WHEN "0011101111",
"0101000000010" WHEN "0011110000",
"0000100100001" WHEN "0011110001",
"0111000000110" WHEN "0011110010",
"1011000100000" WHEN "0011110011",
"0101000000010" WHEN "0011110100",
"0010100100000" WHEN "0011110101",
"0111111110111" WHEN "0011110110",
"1001000100000" WHEN "0011110111",
"0111100110100" WHEN "0011111000",
"1001100110000" WHEN "0011111001",
"0111000101011" WHEN "0011111010",
"0000100000010" WHEN "0011111011",
"1011000000011" WHEN "0011111100",
"0101000000010" WHEN "0011111101",
"0111000101011" WHEN "0011111110",
"1000000000000" WHEN "0011111111",
"1001111000000" WHEN "0100000000",
"0000100000001" WHEN "0100000001",
"1011000000011" WHEN "0100000010",
"0101000000010" WHEN "0100000011",
"0111000101011" WHEN "0100000100",
"1000000000000" WHEN "0100000101",
"1001111010000" WHEN "0100000110",
"0000100000001" WHEN "0100000111",
"1011000000011" WHEN "0100001000",
"0101000000010" WHEN "0100001001",
"0111000101011" WHEN "0100001010",
"1000000000000" WHEN "0100001011",
"1001111100000" WHEN "0100001100",
"0000100000001" WHEN "0100001101",
"1011000000011" WHEN "0100001110",
"0101000000010" WHEN "0100001111",
"0111000101011" WHEN "0100010000",
"1000000000000" WHEN "0100010001",
"1001111110000" WHEN "0100010010",
"0100000100101" WHEN "0100010011",
"1011100010000" WHEN "0100010100",
"0111000000011" WHEN "0100010101",
"0000100010000" WHEN "0100010110",
"1100000100000" WHEN "0100010111",
"0111000001001" WHEN "0100011000",
"0000100010000" WHEN "0100011001",
"0010100000000" WHEN "0100011010",
"1010100100001" WHEN "0100011011",
"0111111111001" WHEN "0100011100",
"1001000100000" WHEN "0100011101",
"0111111111000" WHEN "0100011110",
"1001000010000" WHEN "0100011111",
"0111001100100" WHEN "0100100000",
"0011001110000" WHEN "0100100001",
"0111000000010" WHEN "0100100010",
"0000100000111" WHEN "0100100011",
"1000000000000" WHEN "0100100100",
"1001100100000" WHEN "0100100101",
"0010100000000" WHEN "0100100110",
"1011000000010" WHEN "0100100111",
"0101000000010" WHEN "0100101000",
"0100110111101" WHEN "0100101001",
"0100000001110" WHEN "0100101010",
"1011100010000" WHEN "0100101011",
"0111000000011" WHEN "0100101100",
"0000100010000" WHEN "0100101101",
"1100000100000" WHEN "0100101110",
"0111000001001" WHEN "0100101111",
"0000100010000" WHEN "0100110000",
"0010100000000" WHEN "0100110001",
"1010100100001" WHEN "0100110010",
"0111111111001" WHEN "0100110011",
"1001000100000" WHEN "0100110100",
"0111111111000" WHEN "0100110101",
"1001000010000" WHEN "0100110110",
"0100000000001" WHEN "0100110111",
"0111000000001" WHEN "0100111000",
"0011000010000" WHEN "0100111001",
"0110000110000" WHEN "0100111010",
"0010100100000" WHEN "0100111011",
"0010101110000" WHEN "0100111100",
"0011010000001" WHEN "0100111101",
"0111001100100" WHEN "0100111110",
"0000100000111" WHEN "0100111111",
"1000000000000" WHEN "0101000000",
"1001101100000" WHEN "0101000001",
"0011000000011" WHEN "0101000010",
"1010000001000" WHEN "0101000011",
"1011000100000" WHEN "0101000100",
"0101000011011" WHEN "0101000101",
"0111001110100" WHEN "0101000110",
"0000100000111" WHEN "0101000111",
"1000000000000" WHEN "0101001000",
"1001101000000" WHEN "0101001001",
"0111010000100" WHEN "0101001010",
"0000100000111" WHEN "0101001011",
"1000000000000" WHEN "0101001100",
"1001101010000" WHEN "0101001101",
"0010100000000" WHEN "0101001110",
"0000101000001" WHEN "0101001111",
"1010101010000" WHEN "0101010000",
"0101000001010" WHEN "0101010001",
"0111001110100" WHEN "0101010010",
"0000100000111" WHEN "0101010011",
"1000000000000" WHEN "0101010100",
"1001001000000" WHEN "0101010101",
"0111010000100" WHEN "0101010110",
"0000100000111" WHEN "0101010111",
"1000000000000" WHEN "0101011000",
"1001001010000" WHEN "0101011001",
"0100000010010" WHEN "0101011010",
"0111001100100" WHEN "0101011011",
"0000100000111" WHEN "0101011100",
"1000000000000" WHEN "0101011101",
"1000100000000" WHEN "0101011110",
"0100000001101" WHEN "0101011111",
"0111001110100" WHEN "0101100000",
"0000100000111" WHEN "0101100001",
"1000000000000" WHEN "0101100010",
"1000100000000" WHEN "0101100011",
"0111001110100" WHEN "0101100100",
"0000100000111" WHEN "0101100101",
"1000000000000" WHEN "0101100110",
"1000100000000" WHEN "0101100111",
"0111001100100" WHEN "0101101000",
"0000100000111" WHEN "0101101001",
"1000000000000" WHEN "0101101010",
"1000100000001" WHEN "0101101011",
"0111001101100" WHEN "0101101100",
"0000100000111" WHEN "0101101101",
"1000000000000" WHEN "0101101110",
"1000100000000" WHEN "0101101111",
"1011000100110" WHEN "0101110000",
"0101000001100" WHEN "0101110001",
"0111001100100" WHEN "0101110010",
"0000100000111" WHEN "0101110011",
"1000000000000" WHEN "0101110100",
"1001101100000" WHEN "0101110101",
"1011000100110" WHEN "0101110110",
"0101000000010" WHEN "0101110111",
"0100000000101" WHEN "0101111000",
"0111001101100" WHEN "0101111001",
"0000100000111" WHEN "0101111010",
"1000000000000" WHEN "0101111011",
"1000100000001" WHEN "0101111100",
"0000101110001" WHEN "0101111101",
"0000110001000" WHEN "0101111110",
"0101000000010" WHEN "0101111111",
"0100101000010" WHEN "0110000000",
"0111000000001" WHEN "0110000001",
"0011000010000" WHEN "0110000010",
"0010100000000" WHEN "0110000011",
"0111111111100" WHEN "0110000100",
"1001100100000" WHEN "0110000101",
"0111111111011" WHEN "0110000110",
"1001100110000" WHEN "0110000111",
"0000100100001" WHEN "0110001000",
"1010100110000" WHEN "0110001001",
"0111111111100" WHEN "0110001010",
"1001000100000" WHEN "0110001011",
"0111111111011" WHEN "0110001100",
"1001000110000" WHEN "0110001101",
"0101000000010" WHEN "0110001110",
"0100000110010" WHEN "0110001111",
"0000110110001" WHEN "0110010000",
"0111000000011" WHEN "0110010001",
"1010010110000" WHEN "0110010010",
"0111000000010" WHEN "0110010011",
"1011000001011" WHEN "0110010100",
"0101000011111" WHEN "0110010101",
"0111000000001" WHEN "0110010110",
"1011000001011" WHEN "0110010111",
"0101000010100" WHEN "0110011000",
"0111000000000" WHEN "0110011001",
"1011000001011" WHEN "0110011010",
"0101000001001" WHEN "0110011011",
"0010100000000" WHEN "0110011100",
"0110110010000" WHEN "0110011101",
"0111000000111" WHEN "0110011110",
"0110110000000" WHEN "0110011111",
"1000011110000" WHEN "0110100000",
"1001100000000" WHEN "0110100001",
"0110110010000" WHEN "0110100010",
"0100000011000" WHEN "0110100011",
"0010100000000" WHEN "0110100100",
"0110110010000" WHEN "0110100101",
"0111000001011" WHEN "0110100110",
"0110110000000" WHEN "0110100111",
"1000011100000" WHEN "0110101000",
"1001100000000" WHEN "0110101001",
"0110110010000" WHEN "0110101010",
"0100000010000" WHEN "0110101011",
"0010100000000" WHEN "0110101100",
"0110110010000" WHEN "0110101101",
"0111000001101" WHEN "0110101110",
"0110110000000" WHEN "0110101111",
"1000011010000" WHEN "0110110000",
"1001100000000" WHEN "0110110001",
"0110110010000" WHEN "0110110010",
"0100000001000" WHEN "0110110011",
"0010100000000" WHEN "0110110100",
"0110110010000" WHEN "0110110101",
"0111000001110" WHEN "0110110110",
"0110110000000" WHEN "0110110111",
"1000011000000" WHEN "0110111000",
"1001100000000" WHEN "0110111001",
"0110110010000" WHEN "0110111010",
"0111111111010" WHEN "0110111011",
"1001100010000" WHEN "0110111100",
"0111000000001" WHEN "0110111101",
"0000100010000" WHEN "0110111110",
"1001000010000" WHEN "0110111111",
"0100000000001" WHEN "0111000000",
"0111111111001" WHEN "0111000001",
"1001100000000" WHEN "0111000010",
"0111111111000" WHEN "0111000011",
"1001100010000" WHEN "0111000100",
"1100100000001" WHEN "0111000101",
"0100110001110" WHEN "0111000110",
"0000000000000" when others;
end behavioural;
