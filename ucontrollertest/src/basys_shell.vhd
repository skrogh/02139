library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity basys_shell is
	port(	RESET_ASYNC  : in std_logic;
         CLK    : in std_logic;
			I_0_ASYNC     :   in  std_logic_vector( 7 downto 0 );
         I_1_ASYNC     :   in  std_logic_vector( 7 downto 0 );
			O_0     :   out std_logic_vector( 7 downto 0 );
         O_1     :   out std_logic_vector( 7 downto 0 );
			O_2     :   out std_logic_vector( 7 downto 0 ));
end basys_shell;

architecture structural of basys_shell is
component operations is 
	port(   OP      : in std_logic_vector( 4 downto 0 ); -- operation decoder

            RESET  : in std_logic;
            CLK    : in std_logic;
            RAM_P  : in std_logic_vector( 7 downto 0 );
            RAM_D  : in std_logic_vector( 7 downto 0 );
            OP_D   : in std_logic_vector( 7 downto 0 );  -- the content of destiantion operand
            OP_S   : in std_logic_vector( 7 downto 0 );  -- ---||---- og source --||--
            IO_D   : in std_logic_vector( 7 downto 0 );  -- content of IO destination register
            IO_S   : in std_logic_vector( 7 downto 0 );  -- content of IO source register
            OP_DC  : in std_logic_vector( 3 downto 0 );  -- the code for op_D
            OP_SC  : in std_logic_vector( 3 downto 0 );  -- same for op_S
            IO_D_N : out std_logic_vector( 7 downto 0 ); -- content to update IO_D with
            OP_D_N : out std_logic_vector( 7 downto 0 ); -- content to be put on OP_D register
            PC_N_O : out std_logic_vector( 9 downto 0 ); -- Program counter
            RAM_P_N : out std_logic_vector( 7 downto 0 );
            RAM_D_N : out std_logic_vector( 7 downto 0 );
            RAM_W   : out std_logic;
            RAM_SET : out std_logic;
            byte_set : out std_logic
        );
		  end component;

component reg is
	port(   CLK    :   in      std_logic;
            RESET   :   in      std_logic;
            I_0     :   in  std_logic_vector( 7 downto 0 );
            I_1     :   in  std_logic_vector( 7 downto 0 );
            OP_DC : in      std_logic_vector(3 downto 0);
            OP_SC : in      std_logic_vector(3 downto 0);
            byte_set : in std_logic;
            ram_set : in std_logic; 
            RAM_P_N   : in std_logic_vector( 7 downto 0 );  
            OP_D_N: in      std_logic_vector(7 downto 0);
            IO_D_N  :   in  std_logic_vector( 7 downto 0 );
            O_0     :   out std_logic_vector( 7 downto 0 );
            O_1     :   out std_logic_vector( 7 downto 0 );
				O_2     :   out std_logic_vector( 7 downto 0 );
            IO_D    :   out std_logic_vector( 7 downto 0 );
            IO_S    :   out std_logic_vector( 7 downto 0 );
            OP_D    :   out std_logic_vector(7 downto 0);
            RAM_P   :   out std_logic_vector( 7 downto 0 );
            OP_S    :   out std_logic_vector(7 downto 0)
        );
	end component;
	
component rom is
	port(   addr : in std_logic_vector( 9 downto 0 );
            do : out std_logic_vector( 12 downto 0 ) );
	end component;

component ram is
    port(   clk  : in std_logic;
            din  : in std_logic_vector( 7 downto 0 );
            addr : in std_logic_vector( 7 downto 0 );
            w_en   : in std_logic;
            do   : out std_logic_vector( 7 downto 0 ) );
    end component;

component inputsync is
    port(   clk : in std_logic;
            reset : in std_logic;
            I_0_ASYNC : in std_logic_vector( 7 downto 0 );
            I_1_ASYNC : in std_logic_vector( 7 downto 0 );
            I_1_SYNC : out std_logic_vector( 7 downto 0 );
            I_0_SYNC : out std_logic_vector( 7 downto 0 );
            reset_sync : out std_logic_vector( 7 downto 0 ) );
    end component;

signal OP_D_N, IO_D_N, IO_D, IO_S, OP_D, OP_S : std_logic_vector( 7 downto 0 );
signal OP_DC, OP_SC : std_logic_vector( 3 downto 0 );
signal byte_set : std_logic;
signal OP : std_logic_vector( 4 downto 0 );
signal PC_N_O : std_logic_vector( 9 downto 0 );
signal OP_C : std_logic_vector( 12 downto 0 );
signal PC : std_logic_vector( 9 downto 0 );
signal RAM_P_N, RAM_D_N, RAM_D, RAM_P : std_logic_vector( 7 downto 0 );
signal RESET : std_logic;
signal I_0, I_1 : std_logic_vector( 7 downto 0 ); 
signal RAM_W, RAM_SET : std_logic;

begin

process( CLK, RESET ) 
	begin
		if RESET = '1' then
			PC_N_O <= (others => '0');
		elsif rising_edge( clk ) then
			PC_N_O <= PC;
		end if;
	end process;
	
    input : inputsync
    port map(   clk => clk,
                reset => RESET_ASYNC,
                I_0_ASYNC => I_0_ASYNC,
                I_1_ASYNC => I_1_ASYNC,
                I_1_SYNC => I_1,
                I_0_SYNC => I_0,
                reset_sync => RESET );

	ops : operations
	port map( 	OP => OP,
					RESET => RESET,
					CLK => CLK,
					RAM_P => RAM_P,
					OP_D => OP_D,
					OP_S => OP_S,
					IO_D => IO_D,
					IO_S => IO_S,
					OP_DC => OP_DC,
					OP_SC => OP_SC,
					IO_D_N => IO_D_N,
					OP_D_N => OP_D_N,
					PC_N_O => PC,
                    RAM_SET => RAM_SET,
                    
                    RAM_P_N => RAM_P_N,
                    RAM_W => RAM_W,
                    RAM_D => RAM_D,
                    RAM_D_N => RAM_D_N,
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
					O_2 => O_2,
					IO_D => IO_D,
					IO_S => IO_S,
					OP_D => OP_D,
               ram_set => RAM_SET,
               RAM_P_N => RAM_P_N,
               RAM_P => RAM_P,
					OP_S => OP_S );
	
	code : rom
	port map( 	addr => PC_N_O,
					do => OP_C );

    rams : ram
    port map(   clk => clk,
                din => RAM_D_N,
                addr => RAM_P_N, --Added next, since this is clocked internally too
                w_en => RAM_W,
                do => RAM_D );
	
	OP <= OP_C( 12 downto 8 );
	OP_DC <= OP_C( 7 downto 4 );
	OP_SC <= OP_C( 3 downto 0 );
					
					
	
end structural;
