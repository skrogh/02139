library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
    port(   clk  : in std_logic;
            din  : in std_logic_vector( 7 downto 0 );
            addr : in std_logic_vector( 7 downto 0 );
            w_en   : in std_logic;
            do   : out std_logic_vector( 7 downto 0 ) );
end ram;

architecture behavioural of ram is
type mem_type is array(0 to 255) of std_logic_vector(7 downto 0);
signal rams : mem_type := ( others => ( others => '0' ) );

begin

    process( clk )
	 begin
        if rising_edge( clk ) then
            if w_en = '1' then
                rams( to_integer( unsigned( addr ) ) ) <= din;
            else
                do <= rams( to_integer( unsigned( addr ) ) );
            end if;
        end if;
    end process;
end behavioural;