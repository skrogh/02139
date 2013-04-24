library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD4DISPLAY is
	port( num1, num2 : in STD_LOGIC_VECTOR( 6 downto 0 );
			clk 		  : in STD_LOGIC;
			reset		  : in STD_LOGIC;
			segments	: out	STD_LOGIC_VECTOR( 7 downto 0 );
			display	: out	STD_LOGIC_VECTOR( 3 downto 0 ) );
end entity;

architecture structural of BCD4DISPLAY is
	
	signal D0, D1, D2, D3 : STD_LOGIC_VECTOR( 3 downto 0 );
	
	component Bit7ToBCD is
    port( BIn : in STD_LOGIC_VECTOR( 6 downto 0 );
           MSD, LSD: out STD_LOGIC_VECTOR( 3 downto 0 ));
	end component;
	
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
	BCD1: Bit7ToBCD port map(num1, D1, D0);
	BCD2: Bit7ToBCD port map(num2, D2, D3);
	seq: SegmentMultiplexer port map(clk, reset, D0, D1, D2, D3, segments, display);
	
end structural;