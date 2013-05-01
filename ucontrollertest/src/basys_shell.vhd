library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity basys_shell is
	port(	RESET  : in std_logic;
         CLK    : in std_logic;
			I_0     :   in  std_logic_vector( 7 downto 0 );
         I_1     :   in  std_logic_vector( 7 downto 0 );
			O_0     :   out std_logic_vector( 7 downto 0 );
         O_1     :   out std_logic_vector( 7 downto 0 ) );
end basys_shell;

architecture structural of basys_shell is
component operations is 
	port(    OP		 : in std_logic_vector( 4 downto 0 ); -- operation decoder

            RESET  : in std_logic;
            CLK    : in std_logic;

            OP_D   : in std_logic_vector( 7 downto 0 );  -- the content of destiantion operand
            OP_S   : in std_logic_vector( 7 downto 0 );  -- ---||---- og source --||--
            IO_D   : in std_logic_vector( 7 downto 0 );  -- content of IO destination register
            IO_S   : in std_logic_vector( 7 downto 0 );  -- content of IO source register
            OP_DC  : in std_logic_vector( 3 downto 0 );  -- the code for op_D
            OP_SC  : in std_logic_vector( 3 downto 0 );  -- same for op_S
            IO_D_N : out std_logic_vector( 7 downto 0 ); -- content to update IO_D with
            OP_D_N : out std_logic_vector( 7 downto 0 ); -- content to be put on OP_D register
            PC_N_O : out std_logic_vector( 9 downto 0 ); -- Program counter
            byte_set : out std_logic
        );
		  end component;

component reg is
	port( CLK	:	in		std_logic;
            RESET	:	in		std_logic;
            I_0     :   in  std_logic_vector( 7 downto 0 );
            I_1     :   in  std_logic_vector( 7 downto 0 );
            OP_DC :	in		std_logic_vector(3 downto 0);
            OP_SC :	in		std_logic_vector(3 downto 0);
            byte_set : in std_logic;			
            OP_D_N:	in		std_logic_vector(7 downto 0);
            IO_D_N  :   in  std_logic_vector( 7 downto 0 );
            O_0     :   out std_logic_vector( 7 downto 0 );
            O_1     :   out std_logic_vector( 7 downto 0 );
            IO_D    :   out std_logic_vector( 7 downto 0 );
            IO_S    :   out std_logic_vector( 7 downto 0 );
            OP_D	:	out	std_logic_vector(7 downto 0);
            OP_S	:	out	std_logic_vector(7 downto 0)
        );
	end component;
	
component rom is
	port(   addr : in std_logic_vector( 9 downto 0 );
            do : out std_logic_vector( 12 downto 0 ) );
	end component;
	
signal OP_D_N, IO_D_N, IO_D, IO_S, OP_D, OP_S : std_logic_vector( 7 downto 0 );
signal OP_DC, OP_SC : std_logic_vector( 3 downto 0 );
signal byte_set : std_logic;
signal OP : std_logic_vector( 4 downto 0 );
signal PC_N_O : std_logic_vector( 9 downto 0 );
signal OP_C : std_logic_vector( 12 downto 0 );
signal PC : std_logic_vector( 9 downto 0 );

begin

process( clk ) 
	begin
		if RESET = '1' then
			PC_N_O <= (others => '0');
		elsif rising_edge( clk ) then
			PC_N_O <= PC;
		end if;
	end process;
	
	ops : operations
	port map( 	OP => OP,
					RESET => RESET,
					CLK => CLK,
					OP_D => OP_D,
					OP_S => OP_S,
					IO_D => IO_D,
					IO_S => IO_S,
					OP_DC => OP_DC,
					OP_SC => OP_SC,
					IO_D_N => IO_D_N,
					OP_D_N => OP_D_N,
					PC_N_O => PC,
					byte_set => byte_set );
	
	regs : reg
	port map( 	CLK => CLK,
					RESET => RESET,
					I_0 => I_0,
					I_1 => I_1,
					OP_DC => OP_DC,
					OP_SC => OP_SC,
					byte_set => byte_set,
					OP_D_N => OP_D_N,
					IO_D_N => IO_D_N,
					O_0 => O_0,
					O_1 => O_1,
					IO_D => IO_D,
					IO_S => IO_S,
					OP_D => OP_D,
					OP_S => OP_S );
	
	code : rom
	port map( 	addr => PC_N_O,
					do => OP_C );
	
	OP <= OP_C( 12 downto 8 );
	OP_DC <= OP_C( 7 downto 4 );
	OP_SC <= OP_C( 3 downto 0 );
					
					
	
end structural;
