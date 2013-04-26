library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg is
    port(   CLK	:	in		std_logic;
				RESET	:	in		std_logic;
	 
				OP_DC :	in		std_logic_vector(3 downto 0);
				OP_SC :	in		std_logic_vector(3 downto 0);
				
				OP_D_N:	in		std_logic_vector(7 downto 0);
				OP_D	:	out	std_logic_vector(7 downto 0);
				OP_S	:	out	std_logic_vector(7 downto 0)
				);
end reg;

architecture behavioural of reg is
	type mem_type is array(0 to 31) of std_logic_vector(7 downto 0);
	signal r : mem_type := (others => (others => '0'));
begin
	
	-- register loading
	process( CLK, RESET ) begin
		if RESET = '1' then
			r <= (others => (others => '0'));
		elsif rising_edge( CLK ) then
			--use 32 enables, or hope this will be infered as demux?
			r( to_integer( unsigned( OP_DC ) ) ) <= OP_D_N;
		end if;
	end process;
	
	-- register output
	OP_D <= r( to_integer( unsigned( OP_DC ) ) );
	OP_S <= r( to_integer( unsigned( OP_SC ) ) );
	
end behavioural;

