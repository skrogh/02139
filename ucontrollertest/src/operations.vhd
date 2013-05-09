library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity operations is
    port(   OP		 : in std_logic_vector( 4 downto 0 ); -- operation decoder

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

begin
    -- Route internal PC to external
    PC_N_O <= PC_N;

    -- Registers
    process( CLK, RESET ) begin
        if RESET = '1' then
            -- Carry
            C <= (others => '0');

            -- I/O


            -- Program counter internal
            PC_INT <= (others => '0');
        elsif rising_edge( CLK ) then
            if C_E = '1' then
                C <= C_N;
            end if;
            PC_INT <= PC_N;			
        end if;
    end process;

-- Combinatorical logic
process( OP, OP_D, OP_S, PC_INT, OP_SC, OP_DC, ADDER, IO_D, IO_S, C, RAM_P, RAM_D ) begin
    OP_D_N <= OP_D;
    IO_D_N <= IO_D;
    RAM_P_N <= RAM_P;
    RAM_D_N <= RAM_D;
    PC_N <= std_logic_vector( unsigned( PC_INT ) + 1 ); -- Increment program counter pr default;
    C_N <= (others => '0'); -- Don't care ok?
    C_E <= '0';
    ADDER <= (others => '0'); -- Don't care ok?
    byte_set <= '0';
    RAM_SET <= '0';
	 RAM_W <= '0';
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
        when	"00110"	=>	-- MOC set register D to content of S
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
        when    "01100" => --rio read io register
            OP_D_N <= IO_S;
        when    "01101" => --sio set io register
            IO_D_N <= OP_S;
        when    "01110" => --set r0 to byte value
            OP_D_N <= OP_DC & OP_SC;
            byte_set <= '1';
        when    "01111" => --set ram address to byte value
            RAM_P_N <= OP_DC & OP_SC;
            RAM_SET <= '1';
        when    "10000" => --set ram address to register value
            RAM_P_N <= OP_D;
            RAM_SET <= '1';
        when    "10001" => --set ram value to byte value
            RAM_D_N <= OP_DC & OP_SC;
            RAM_W <= '1';
        when    "10010" => --set ram value to register value
            RAM_D_N <= OP_D;
            RAM_W <= '1';
        when    "10011" => --read ram value into OP_D
            OP_D_N <= RAM_D;
        when others => 
            PC_N <= PC_INT; -- don't continue	
    end case;
end process;
    end behavioural;

