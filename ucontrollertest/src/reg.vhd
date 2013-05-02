library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg is
    port(   CLK	:	in		std_logic;
            RESET	:	in		std_logic;
            I_0     :   in  std_logic_vector( 7 downto 0 );
            I_1     :   in  std_logic_vector( 7 downto 0 );
            OP_DC :	in		std_logic_vector(3 downto 0);
            OP_SC :	in		std_logic_vector(3 downto 0);
            byte_set : in std_logic;
            ram_set : in std_logic;	
            RAM_P_N   : in std_logic_vector( 7 downto 0 );	
            OP_D_N:	in		std_logic_vector(7 downto 0);
            IO_D_N  :   in  std_logic_vector( 7 downto 0 );
            O_0     :   out std_logic_vector( 7 downto 0 );
            O_1     :   out std_logic_vector( 7 downto 0 );
            IO_D    :   out std_logic_vector( 7 downto 0 );
            IO_S    :   out std_logic_vector( 7 downto 0 );
            OP_D	:	out	std_logic_vector(7 downto 0);
            RAM_P   :   out std_logic_vector( 7 downto 0 );
            OP_S	:	out	std_logic_vector(7 downto 0)
        );
end reg;

architecture behavioural of reg is

    type mem_type is array(0 to 15) of std_logic_vector(7 downto 0);
    signal r : mem_type := (others => (others => '0'));
    signal io_r : mem_type := (others => (others => '0' ) );
    signal RAM_REG : std_logic_vector( 7 downto 0 ) := ( others => '0' );
begin

    -- register loading
    process( CLK, RESET ) begin
        if RESET = '1' then
            io_r <= ( others => ( others => '0' ) );
            r <= (others => (others => '0'));
            RAM_REG <= ( others => '0' );
        elsif rising_edge( CLK ) then
            if byte_set = '1' then
                r( 0 ) <= OP_D_N;
            elsif ram_set = '1' then
                RAM_REG <= RAM_P_N;
            else
            --use 32 enables, or hope this will be infered as demux?
                r( to_integer( unsigned( OP_DC ) ) ) <= OP_D_N;
                io_r( to_integer( unsigned( OP_DC ) ) ) <= IO_D_N;

                io_r( 0 ) <= I_0;
                io_r( 1 ) <= I_1;
            end if;
        end if;
    end process;

    -- register output
    OP_D <= r( to_integer( unsigned( OP_DC ) ) );
    OP_S <= r( to_integer( unsigned( OP_SC ) ) );
    RAM_P <= RAM_REG;

    IO_D <= io_r( to_integer( unsigned( OP_DC ) ) );
    IO_S <= io_r( to_integer( unsigned( OP_SC ) ) );

    O_0 <= io_r( 8 );
    O_1 <= io_r( 9 );

end behavioural;

