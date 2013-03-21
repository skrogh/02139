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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopTest is
	port(
			clk		: in	STD_LOGIC;
			reset		: in	STD_LOGIC;
			digit0	: in	STD_LOGIC_VECTOR( 3 downto 0 );
			digit3	: in	STD_LOGIC_VECTOR( 3 downto 0 );
			
			segments	: out	STD_LOGIC_VECTOR( 7 downto 0 );
			display	: out	STD_LOGIC_VECTOR( 3 downto 0 )
			);
end TopTest;

architecture Behavioral of TopTest is
	component SegmentMultiplexer is
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
	end component;
begin	
	
	segMux: SegmentMultiplexer port map(
		clk => clk,
		reset => reset,
		digit0 => digit0,
		digit1 => "0000",
		digit2 => "0000",
		digit3 => digit3,
		
		segments => segments,
		display => display		
		);
		
end Behavioral;