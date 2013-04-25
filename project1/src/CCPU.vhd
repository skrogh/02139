library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CCPU is
	port ( coin2 : in std_logic;
		   coin5 : in std_logic;
		   reset : in std_logic;
		   buy : in std_logic;
		   price : in std_logic_vector( 4 downto 0 );
	  	   clk : in std_logic;
		   release_can : out std_logic;
		   alarm_signal : out std_logic;
		   total_out : out std_logic_vector( 6 downto 0 );
		   price_out : out std_logic_vector( 4 downto 0 ) );
				 
	end CCPU;
	
architecture ASM of CCPU is
	type state_type is ( waiting, dispense, add2, add5, alarm );
	signal state_reg : state_type;
	signal next_state : state_type;
	signal total_reg : std_logic_vector( 6 downto 0 );
	signal total_reg_next : std_logic_vector( 6 downto 0 );
begin

	total_out <= total_reg;
	price_out <= price;
	
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
	
end ASM;

architecture FSMD of CCPU is
	--FSM
	type state_type is ( waiting, dispense, add2, add5, alarm );
	signal state_reg : state_type;
	signal next_state : state_type;
	
	--FSM/Datapath I/O
	--FSM O DP I
	signal total_en : std_logic;
	signal sub_price : std_logic;
	signal add_five : std_logic;
	--FSM I DP O
	signal price_comp : std_logic;
	
	--Datapath
	--Registers
	signal total_reg : std_logic_vector( 6 downto 0 );
	signal total_reg_next : std_logic_vector( 6 downto 0 );	
	--Internal
	signal adder_out : std_logic_vector(7 downto 0 );
	signal adder_in : std_logic_vector(4 downto 0 );
	
begin

	--Outputs for display
	total_out <= total_reg;
	price_out <= price;
	
	--FSM Register
	process( clk, reset )
	begin	
		if reset = '1' then
			state_reg <= waiting;
		elsif rising_edge( clk ) then
			state_reg <= next_state;
		end if;
	end process;
	
	--FSM
	process( coin2, coin5, buy, price, state_reg, total_reg )
	begin
		--Outputs
		alarm_signal <= '0';
		release_can <= '0';
		--Controllers
		total_en = '0';
		sub_price = '0';
		add_five = '0';
		--Statedefault
		next_state <= waiting;
		--Pick next state
		case state_reg is
			when waiting => 
				if coin5 = '1' then
					--Add 5 to total
					total_en = '1';
					add_five = '1';
					next_state <= add5;
				elsif coin2 = '1' then
					--Add 2 to total
					total_en = '1';
					add_five = '0'; --Redundant
					next_state <= add2;
				elsif buy = '1' then
					if not(price_comp) then --!(Price > total)
						--Subtract price from total
						total_en = '1';
						sub_price = '1';
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
				--total_reg_next <= (others=>'0');
				next_state <= waiting;
		end case;
	end process;
	
	--DataPath Register
	process( clk, reset, total_en )
	begin	
		if reset = '1' then
			total_reg <= (others => '0');
		elsif ( rising_edge( clk ) and total_en ) then
			total_reg <= total_reg_next;
		end if;
	end process;
	
	--DataPath
	process( sub_price, add_five )
	begin
		--Adder
		adder_in => "00000";
		case (sub_price & add_five) is
			when "00" => --Add two
				adder_in => "00010";
			when "01" => --Add five
				adder_in => "00101";
			when "10" => --Subtract price (for comparison or other)
				adder_in => NOT price;
			when others => --Other combinations (11) not possible, defalut to "00000"
		end case
		adder_out <= std_logic_vector( unsigned(total_reg) + unsigned(sub_price) + unsigned(adder_in) );
		total_reg_next <= adder_out(6 downto 0);
		--Comparator (can be implimentet with the adder, but has to be used in same clock period. A slower, smaller FSM could be made)
		price_comp <= not (total_reg < price);
	end process;
	
end FSMD;
