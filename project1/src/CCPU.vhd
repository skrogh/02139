library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CCPU is
	port ( coin2 : in std_logic;
		   coin5 : in std_logic;
		   reset : in std_logic;
		   buy : in std_logic;
		   price : in std_logic_vector( 5 downto 0 );
	  	   clk : in std_logic;
		   release_can : out std_logic;
		   alarm_signal : out std_logic;
		   total_out : out std_logic_vector( 6 downto 0 );
		   price_out : out std_logic_vector( 6 downto 0 ) );
				 
	end CCPU;
	
architecture behavioural of CCPU is
	type state_type is ( waiting, dispense, add2, add5, alarm );
	signal state_reg : state_type;
	signal next_state : state_type;
	signal total_reg : std_logic_vector( 6 downto 0 );
	signal total_reg_next : std_logic_vector( 6 downto 0 );
begin

	total_out <= total_reg;
	price_out <= '0' & price;
	
	process( clk, reset )
	begin	
		if reset = '1' then
			state_reg <= waiting;
			total_reg <= (others => '0');
		elsif rising_edge( clk ) then
			state_reg <= next_state;
			total_reg <= total_reg_next;
		end if;
	end process;
	
	process( coin2, coin5, buy, price, state_reg, total_reg )
	begin
		alarm_signal <= '0';
		release_can <= '0';
		total_reg_next <= total_reg;
		next_state <= waiting;
		case state_reg is
			when waiting => 
				if coin5 = '1' then
					total_reg_next <= std_logic_vector(unsigned(total_reg) + 5);
					next_state <= add5;
				elsif coin2 = '1' then
					total_reg_next <= std_logic_vector(unsigned(total_reg) + 2);
					next_state <= add2;
				elsif buy = '1' then
					if not(unsigned(total_reg) < unsigned(price)) then
						total_reg_next <= std_logic_vector(unsigned(total_reg) - unsigned(price) );
						next_state <= dispense;
					else
						next_state <= alarm;
					end if;
				end if;
			when alarm =>
				alarm_signal <= '1';
				if buy = '1' then
					next_state <= alarm;
				else
					next_state <= waiting;
				end if;
			when dispense =>
				release_can <= '1';
				if buy = '1' then
					next_state <= dispense;
				else
					next_state <= waiting;
				end if;
			when add2 =>
				if coin2 = '1' then
					next_state <= add2;
				else
					next_state <= waiting;
				end if;
			when add5 =>
				if coin5 = '1' then
					next_state <= add5;
				else
					next_state <= waiting;
				end if;
			when others =>
				total_reg_next <= (others=>'0');
				next_state <= waiting;
		end case;
	end process;
	
end behavioural;