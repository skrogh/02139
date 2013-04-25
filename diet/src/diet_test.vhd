library IEEE;
use IEEE.std_logic_1164.all;

entity test is 
    port(   addr : in std_logic_vector( 6 downto 0 );
            do : out std_logic_vector( 3 downto 0 );
            clk : in std_logic;
            reset : in std_logic );
end test;

architecture behavioural of test is
    signal addr_reg : std_logic_vector( 3 downto 0 );

    component diet_rom is
        port(   addr : in std_logic_vector( 6 downto 0 );
                do   : out std_logic_vector( 3 downto 0 ) );
    end component;
begin

    process( clk, reset ) 
    begin
        if reset = 1 then
            addr_reg <= (others => '0');
        elsif rising_edge( clk ) then
            addr_reg <= addr;
        end if;
    end process;

    ROM : diet_rom 
        port map(   addr => addr_reg,
                    do => do );

end behavioural;
