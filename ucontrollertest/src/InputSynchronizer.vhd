library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity InputSynchronizer is
    port(   clk : in std_logic;
            reset : in std_logic;
            I_0_ASYNC : in std_logic_vector( 7 downto 0 );
            I_1_ASYNC : in std_logic_vector( 7 downto 0 );
            I_1_SYNC : out std_logic_vector( 7 downto 0 );
            I_0_SYNC : out std_logic_vector( 7 downto 0 );
            reset_sync : out std_logic_vector( 7 downto 0 ) );
end InputSynchronizer

architecture behavioural of InputSynchronizer is
    signal reset_r : std_logic;
    signal I_0_r, I_1_r : std_logic_vector( 7 downto 0 );
begin
    --output
    I_0_SYNC <= I_0_r;
    I_1_SYNC <= I_1_r;
    reset_sync <= reset_r;

    --ff buffer
    process( clk, reset )
    begin
        if rising_edge( clk ) then
            reset_r <= reset;
            I_0_r <= I_0_ASYNC;
            I_1_r <= I_1_ASYNC;
        end if;
    end process;
end behavioural;
