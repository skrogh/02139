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
				PC_N_O     : out std_logic_vector( 9 downto 0 ) -- Program counter
				);
end operations;

architecture behavioural of operations is
	signal C, C_N : std_logic_vector( 0 downto 0 ); -- Makes converting smoother
	signal C_E : std_logic;
	signal PC_N, PC_INT : std_logic_vector( 9 downto 0 );
	signal ADDER : std_logic_vector( 8 downto 0 );

begin
	-- Route internal PC to external
	PC_N_O <= PC_N;

	-- Registers
	process( CLK, RESET ) begin
		if RESET = '1' then
			C <= (others => '0');
			PC_INT <= (others => '0');
		elsif rising_edge( CLK ) then
			if C_E = '1' then
				C <= C_N;
			end if;
			PC_INT <= PC_N;			
		end if;
	end process;
	
	-- Combinatorical logic
	process( OP, OP_D, OP_S, PC_INT, OP_SC, OP_DC ) begin
		OP_D_N <= OP_D;
		PC_N <= std_logic_vector( unsigned( PC_INT ) + 1 ); -- Incriment program counter pr default;
		C_E <= '1';
		ADDER <= (others => '0'); -- Don't care ok?
		case OP is
			when  "00000"  => -- NOP no operation
			when	"00001"	=>	-- ADD add
				ADDER <= std_logic_vector( unsigned( "0" & OP_D ) + unsigned( OP_S ) );
				OP_D_N <= ADDER(7 downto 0);
				C_E <= '1';
				C <= ADDER(8 downto 8);
			when	"00010"	=>	-- SUB subtract
				ADDER <= std_logic_vector( unsigned( "0" & OP_D ) - unsigned( OP_S ) ); --Or with + ! + 1?
				OP_D_N <= ADDER(7 downto 0);
				C_E <= '1';
				C <= ADDER(8 downto 8);	
			when	"00011"	=>	-- SLN set lower nibble
				OP_D_N <= OP_D(7 downto 4) & OP_SC;
			when	"00100"	=>	-- SHN set higher nibble
				OP_D_N <= OP_SC & OP_D(3 downto 0);
			when	"00101"	=>	-- RES set register to all 0's
				OP_D_N <= "00000000"; -- others => 0 not working
			when	"00110"	=>	-- JMPA absolute jump.
				PC_N <= "0000000000";
			when others => 
				PC_N <= PC_INT; -- don't continue	
			end case;
		end process;
end behavioural;

