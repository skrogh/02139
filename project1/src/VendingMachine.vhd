------------------------------------------------------------------------
-- Top component of the vending machine for the course:
-- 02139 Digital electronics 2 at the Technical University of Denmark
--
-- In this component declares and instantiates all the components of the
-- vending machine.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
  port (
    clk_50        : in  std_logic;
    clk_man       : in  std_logic;
    sel_man       : in  std_logic;
    reset         : in  std_logic;
    coin2         : in  std_logic;
    coin5         : in  std_logic;
    buy           : in  std_logic;
    price         : in  std_logic_vector(4 downto 0);
    release_can   : out std_logic;
    alarm         : out std_logic;
    seven_segment : out std_logic_vector(7 downto 0);
    digit_select  : out std_logic_vector(3 downto 0));

end vending_machine;

architecture struct of vending_machine is
  signal clk            : std_logic;
  signal sync_coin2     : std_logic;
  signal sync_coin5     : std_logic;
  signal sync_buy       : std_logic;
  signal sync_reset		: std_logic;
  signal sum            : std_logic_vector(6 downto 0);
  signal sync_price     : std_logic_vector( 6 downto 0 );
  signal internal_price : std_logic_vector(6 downto 0);

------------------------------------------------------------------------
-- Clock divider component declaration
------------------------------------------------------------------------
  component SlowClock is
    port (
          clk_50 : in std_logic;
          sel_man : in std_logic;
          clk_man : in std_logic;
          reset : in std_logic;
          tickOut : out std_logic );
  end component;

  component CCPU is
    port( coin2 : in std_logic;
          coin5 : in std_logic;
          reset : in std_logic;
          buy : in std_logic;
          price : in std_logic_vector( 6 downto 0 );
          clk : in std_logic;
          release_can : out std_logic;
          alarm_signal : out std_logic;
          total_out : out std_logic_vector( 6 downto 0 );
          price_out : out std_logic_vector( 6 downto 0 ) );       
    end component;

  component InputSynchronizer is
    port( clk : in std_logic;
          reset : in std_logic;
          buy : in std_logic;
          coin2 : in std_logic;
          coin5 : in std_logic;
          price : in std_logic_vector( 4 downto 0 );
          sync_reset : out std_logic;
          sync_buy : out std_logic;
          sync_coin2 : out std_logic;
          sync_coin5 : out std_logic;
          sync_price : out std_logic_vector( 6 downto 0 ) );
  end component;

  component BCD4Display is
    port( num1, num2 : in STD_LOGIC_VECTOR( 6 downto 0 );
          clk       : in STD_LOGIC;
          reset     : in STD_LOGIC;
          segments  : out STD_LOGIC_VECTOR( 7 downto 0 );
          display : out STD_LOGIC_VECTOR( 3 downto 0 ) );
  end component;


------------------------------------------------------------------------
-- Complete the remaining three component declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
  
begin  -- struct

  clock_manager1 : SlowClock
    port map (
      clk_50  => clk_50,
      clk_man => clk_man,
      sel_man => sel_man,
		reset => sync_reset,
      tickOut => clk);

  InputSync : InputSynchronizer
    port map( clk => clk,
              reset => reset,
              buy => buy,
              coin2 => coin2,
              coin5 => coin5,
              price => price,
              sync_reset => sync_reset,
              sync_buy => sync_buy,
              sync_coin2 => sync_coin2,
              sync_coin5 => sync_coin5,
              sync_price => sync_price);

  CPU : CCPU
    port map( coin2 => sync_coin2,
              coin5 => sync_coin5,
              reset => sync_reset,
              buy => sync_buy,
              price => sync_price,
				  clk => clk,
              release_can => release_can,
              alarm_signal => alarm,
              total_out => sum,
              price_out => internal_price);
  Display : BCD4Display
    port map( num1 => internal_price,
              num2 => sum,
              clk => clk,
				  reset => sync_reset,
              segments => seven_segment,
              display => digit_select);


------------------------------------------------------------------------
-- Complete the remaining three component instantiations
------------------------------------------------------------------------


------------------------------------------------------------------------
end struct;
