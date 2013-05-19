library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test is 
	port( CLK : in std_logic;
			RESET : in std_logic;
			LD : out std_logic_vector( 7 downto 0 );
			TG : in std_logic_vector( 7 downto 0 )
			);
end test;

architecture behavioural of test is
	signal PC	  : std_logic_vector( 9 downto 0 );
	signal PC_rom : std_logic_vector( 9 downto 0 );
	signal PRG_LN : std_logic_vector( 12 downto 0 );
	signal OP_D, OP_D_N, OP_S : std_logic_vector( 7 downto 0 );
	signal OP_DC, OP_SC : std_logic_vector( 3 downto 0 );
	
	--COMPONENTS
	component rom is
		port(	addr : in std_logic_vector( 9 downto 0 );
				do   : out std_logic_vector( 12 downto 0 )
				);
	end component;
	
	component reg is
		port(	CLK	:	in		std_logic;
				RESET	:	in		std_logic;
	 
				OP_DC :	in		std_logic_vector(3 downto 0);
				OP_SC :	in		std_logic_vector(3 downto 0);
				
				OP_D_N:	in		std_logic_vector(7 downto 0);
				OP_D	:	out	std_logic_vector(7 downto 0);
				OP_S	:	out	std_logic_vector(7 downto 0)
				);
	end component;
	
	component operations is
		port(	OP		 : in std_logic_vector( 4 downto 0 ); -- operation decoder
	 
				RESET  : in std_logic;
				CLK    : in std_logic;
				OP_D   : in std_logic_vector( 7 downto 0 );  -- the content of destiantion operand
				OP_S   : in std_logic_vector( 7 downto 0 );  -- ---||---- og source --||--
				OP_DC  : in std_logic_vector( 3 downto 0 );  -- the code for op_D
				OP_SC  : in std_logic_vector( 3 downto 0 );  -- same for op_S
				OP_D_N : out std_logic_vector( 7 downto 0 ); -- content to be put on OP_D register
				PC_N_O : out std_logic_vector( 9 downto 0 ); -- Program counter
				
				TG 	 : in  std_logic_vector( 7 downto 0 ); -- Toggles.
				LD_EXT : out std_logic_vector( 7 downto 0 ) -- LEDs external signal.
				);
	end component;
	
	begin
	--Route PGR_LN to OP_DC og OP_SC
	OP_DC <= PRG_LN(7 downto 4);
	OP_SC <= PRG_LN(3 downto 0);

	--ROM module:
	process( clk, RESET ) 
	begin
		if RESET = '1' then
			PC_rom <= (others => '0');
		elsif rising_edge( clk ) then
			PC_rom <= PC; -- and not( RESET & RESET & RESET & RESET & RESET & RESET & RESET & RESET & RESET & RESET ); -- synchronius reset
		end if;
	end process;
	
	PROGRAM : rom 
	port map(	addr => PC_rom,
					do => PRG_LN );
					
	--Registers/memory
	REGISTERS : reg 
	port map(	CLK	=> CLK,
					RESET	=> RESET,
		 
					OP_DC => OP_DC,
					OP_SC => OP_SC,
					
					OP_D_N=> OP_D_N,
					OP_D	=> OP_D,
					OP_S	=> OP_S
					);
					
	--Operations
	OPERAT : operations 
	port map(	OP => PRG_LN(12 downto 8),
	
					CLK	=> CLK,
					RESET	=> RESET,
					
					OP_D	=> OP_D,
					OP_S	=> OP_S,
					OP_DC => OP_DC,
					OP_SC => OP_SC,
					OP_D_N=> OP_D_N,
					PC_N_O=> PC,
					
					TG		=>	TG,
					LD_EXT=>	LD
					);	
	
end behavioural;
