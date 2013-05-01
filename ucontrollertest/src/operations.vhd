library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity operations is
    port(   OP		 : in std_logic_vector( 4 downto 0 ); -- operation decoder
	 
				RESET  : in std_logic;
				CLK    : in std_logic;
				
				OP_D   : in std_logic_vector( 7 downto 0 );  -- the content of destiantion operand
				OP_S   : in std_logic_vector( 7 downto 0 );  -- ---||---- og source --||--
				OP_DC  : in std_logic_vector( 3 downto 0 );  -- the code for op_D
				OP_SC  : in std_logic_vector( 3 downto 0 );  -- same for op_S
				OP_D_N : out std_logic_vector( 7 downto 0 ); -- content to be put on OP_D register
				PC_N_O : out std_logic_vector( 9 downto 0 ); -- Program counter
				
				TG 	 : in  std_logic_vector( 7 downto 0 ); -- Toggles.
				LD_EXT   : out std_logic_vector( 7 downto 0 ) -- LEDs external signal.
				);
end operations;

architecture behavioural of operations is
	-- Carry register
	signal C, C_N : std_logic_vector( 0 downto 0 ); -- Makes converting smoother
	signal C_E : std_logic;
	
	-- Program counter
	signal PC_N, PC_INT : std_logic_vector( 9 downto 0 );
	
	-- vhdl and noninline concatination...
	signal ADDER : std_logic_vector( 8 downto 0 );
	
	-- I/O registers
	signal LD_E : std_logic;
	signal LD, LD_N : std_logic_vector( 7 downto 0 ); -- LED's over toggles
	signal TG_S, TG_SS : std_logic_vector( 7 downto 0 ); -- LED's over toggles

begin
	-- Route internal PC to external
	PC_N_O <= PC_N;
	LD_EXT <= LD;

	-- Registers
	process( CLK, RESET ) begin
		if RESET = '1' then
			-- Carry
			C <= (others => '0');
			
			-- I/O
			LD <= (others => '0');
			TG_S <= (others => '0');
			TG_SS <= (others => '0');
			
			-- Program counter internal
			PC_INT <= (others => '0');
		elsif rising_edge( CLK ) then
			if C_E = '1' then
				C <= C_N;
			end if;
			if	LD_E = '1' then
				LD <= LD_N;
			end if;
			TG_S <= TG;
			TG_SS <= TG_S;
			PC_INT <= PC_N;			
		end if;
	end process;
	
	-- Combinatorical logic
	process( OP, OP_D, OP_S, PC_INT, OP_SC, OP_DC, ADDER, TG_SS, LD, C ) begin
		OP_D_N <= OP_D;
		PC_N <= std_logic_vector( unsigned( PC_INT ) + 1 ); -- Increment program counter pr default;
		C_N <= (others => '-'); -- Don't care ok?
		C_E <= '0';
		LD_N <= (others => '-'); -- Don't care ok?
		LD_E <= '0';
		ADDER <= (others => '-'); -- Don't care ok?
		case OP is
			when  "00000"  => -- NOP no operation
			when	"00001"	=>	-- ADD add
				ADDER <= std_logic_vector( unsigned( "0" & OP_D ) + unsigned( OP_S ) );
				OP_D_N <= ADDER(7 downto 0);
				C_E <= '1';
				C_N <= ADDER(8 downto 8);
			when	"00010"	=>	-- SUB subtract
				ADDER <= std_logic_vector( unsigned( "0" & OP_D ) - unsigned( OP_S ) ); --Or with + ! + 1?
				OP_D_N <= ADDER(7 downto 0);
				C_E <= '1';
				C_N <= ADDER(8 downto 8);	
			when	"00011"	=>	-- SLN set lower nibble
				OP_D_N <= OP_D(7 downto 4) & OP_SC;
			when	"00100"	=>	-- SHN set higher nibble
				OP_D_N <= OP_SC & OP_D(3 downto 0);
			when	"00101"	=>	-- RES set register to all 0's
				OP_D_N <= "00000000"; -- others => 0 not working
			when	"00110"	=>	-- MOV set register D to content of S
				OP_D_N <= OP_S;	
			when	"00111"	=>	-- JMPA absolute jump.
				PC_N <= "00" & OP_DC & OP_SC;
			when	"01000"	=>	-- JMPA positive jump.
				PC_N <= std_logic_vector( unsigned( PC_INT ) + unsigned( OP_DC & OP_SC ) );
			when	"01001"	=>	-- JMPA negative jump.
				PC_N <= std_logic_vector( unsigned( PC_INT ) - unsigned( OP_DC & OP_SC ) );
			when	"01010"	=>	-- BRNP relative jump positive.
				if C(0) = '1' then
					PC_N <= std_logic_vector( unsigned( PC_INT ) + unsigned( OP_DC & OP_SC ) );
				end if;
			when	"01011"	=>	-- BRNN relative jump negative.
				if C(0) = '1' then
					PC_N <= std_logic_vector( unsigned( PC_INT ) - unsigned( OP_DC & OP_SC ) );
				end if;
			when	"01100"	=>	-- RII read indirect input
				OP_D_N <= TG_SS;
			when	"01101"	=>	-- RIO read indirect output
				OP_D_N <= LD;
			when	"01110"	=>	-- SIO set indirect output
				LD_N <= OP_D;
				LD_E <= '1';
			when	"01111"	=>	-- SDO set indirect output
				LD_N <= OP_DC & OP_SC;
				LD_E <= '1';
			when others => 
				PC_N <= PC_INT; -- don't continue	
			end case;
		end process;
end behavioural;

