----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:58:51 02/28/2013 
-- Design Name: 
-- Module Name:    HexToSevenSegment - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SegmentMultiplexer is
	port(
			clk		: in	STD_LOGIC;
			reset		: in	STD_LOGIC;
			digit0	: in	STD_LOGIC_VECTOR( 3 downto 0 );
			digit1	: in	STD_LOGIC_VECTOR( 3 downto 0 );
			digit2	: in	STD_LOGIC_VECTOR( 3 downto 0 );
			digit3	: in	STD_LOGIC_VECTOR( 3 downto 0 );
			
			segments	: out	STD_LOGIC_VECTOR( 7 downto 0 );
			display	: out	STD_LOGIC_VECTOR( 3 downto 0 )
			);
end SegmentMultiplexer;

architecture Behavioral of SegmentMultiplexer is
	type DIGIT is ( dig0, dig1, dig2, dig3 );
	signal shownDigit, shownDigitN : DIGIT;
	signal currentDigit : STD_LOGIC_VECTOR( 3 downto 0 );

	component HexToSevenSegment is
		port(
			hexIn				: in	STD_LOGIC_VECTOR( 3 downto 0 );
			segmentCode		: out	STD_LOGIC_VECTOR( 7 downto 0 )
		);
	end component;
	

begin
	
	
	
	-- Current digit:
	process( shownDigit, digit0, digit1, digit2, digit3 ) begin
		currentDigit <= "1111";
		case shownDigit is
			when dig0 =>
				currentDigit <= digit0;
			when dig1 =>
				currentDigit <= digit1;
			when dig2 =>
				currentDigit <= digit2;
			when dig3 =>
				currentDigit <= digit3;
		end case;
	end process;
	
	-- Hex Decoder:
	decoder: HexToSevenSegment port map(
			hexIn => currentDigit,
			segmentCode => segments
			);
	
	
	-- Display chooser:
	process( shownDigit ) begin
		display <= "1111";
		case shownDigit is
			when dig0 =>
				display <= "1110";
			when dig1 =>
				display <= "1101";
			when dig2 =>
				display <= "1011";
			when dig3 =>
				display <= "0111";
		end case;
	end process;
	
	-- "Slow clk":
	-- Next state logic:
	process( shownDigit ) begin
		shownDigitN <= dig0;
		case shownDigit is
			when dig0 =>
				shownDigitN <= dig1;
			when dig1 =>
				shownDigitN <= dig2;
			when dig2 =>
				shownDigitN <= dig3;
			when dig3 =>
				shownDigitN <= dig0;
		end case;
	end process;
	
	-- Clk and tick logic:
	process ( clk, reset ) begin
		if reset = '1' then
				shownDigit <= dig0;
		elsif rising_edge( clk ) then
				shownDigit <= shownDigitN;
		end if;
	end process;

end Behavioral;

