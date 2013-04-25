library ieee;
use ieee.std_logic_1164.all;

entity InputSynchronizer is 
    port(   clk : in std_logic;
            reset : in std_logic;
            buy : in std_logic;
            coin2 : in std_logic;
            coin5 : in std_logic;
            price : in std_logic_vector( 4 downto 0 );
            sync_buy : out std_logic;
            sync_coin2 : out std_logic;
            sync_coin5 : out std_logic;
            sync_price : out std_logic_vector( 4 downto 0 ) );
end InputSynchronizer;

architecture behavioural of InputSynchronizer is
    signal buy_r, coin2_r, coin5_r : std_logic;
    signal price_r : std_logic_vector( 4 downto 0 );
begin
    --sync output
    sync_buy <= buy_r;
    sync_coin2 <= coin2_r;
    sync_coin5 <= coin5_r;
    sync_price <= price_r;

    --ff process
    process( clk, reset )
    begin
        if reset = '1' then
            buy_r <= '0';
            coin2_r <= '0';
            coin5_r <= '0';
            price_r <= (others =>'0');
        elsif rising_edge( clk ) then
            buy_r <= buy;
            coin2_r <= coin2;
            coin5_r <= coin5;
            price_r <= price;
        end if;
    end process;
end behavioural;
