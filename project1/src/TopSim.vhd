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

entity TopSim is
end TopSim;

architecture Behavioral of TopSim is

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
	
	signal clk : STD_LOGIC := '1';
	signal reset : STD_LOGIC := '1';
	signal digit0 : STD_LOGIC_VECTOR( 3 downto 0 ) := "0001";
	signal digit1 : STD_LOGIC_VECTOR( 3 downto 0 ) := "0010";
	signal digit2 : STD_LOGIC_VECTOR( 3 downto 0 ) := "0100";
	signal digit3 : STD_LOGIC_VECTOR( 3 downto 0 ) := "1000";
	
	signal segments : STD_LOGIC_VECTOR( 7 downto 0 );
	signal display : STD_LOGIC_VECTOR( 3 downto 0 );
	
begin	
	
	-- 100 MHz clock
	process
		begin
		wait for 5 ns; clk <= not clk;
	end process;
	-- reset
	process
		begin
		wait for 15 ns;
		reset <= '0';
		wait;
	end process;
	
	segMux: SegmentMultiplexer port map(
		clk, reset,	digit0, digit1, digit2,	digit3,	
		segments, display	);
		
end Behavioral;