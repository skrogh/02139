library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SlowClock is
	port (
		clk_50 : in std_logic;
		sel_man : in std_logic;
		clk_man : in std_logic;
		reset : in std_logic;
		tickOut : out std_logic );
end SlowClock;

architecture Behavioral of SlowClock is
	constant CLK_FREQ : integer := 50000000;--50000000; -- 50 MHz
	constant BLINK_FREQ : integer := 25000000;--4000;--1; -- 4000 Hz
	constant CNT_MAX : integer := CLK_FREQ/BLINK_FREQ-1;
	signal cnt, cnt_reg : unsigned( 30 downto 0 );
	signal tick : std_logic;

begin	
	process ( cnt_reg, sel_man, clk_man ) begin
		tick <= '0';
		cnt <= (others => '0');
		if sel_man = '1' then
			tick <= clk_man;
		elsif cnt_reg = CNT_MAX then
			cnt <= ( others => '0' );
			tick <= '1';
		else
			cnt <= cnt_reg + 1;
		end if;
	end process;
	
	process ( clk_50, reset ) begin
		if reset='1' then
			cnt_reg <= (others => '0');
		elsif rising_edge(clk_50) then
			cnt_reg <= cnt;
		end if;
	end process;
	
	tickOut <= tick;

end Behavioral;
