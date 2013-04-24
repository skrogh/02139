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
  signal sum            : std_logic_vector(7 downto 0);
  signal internal_price : std_logic_vector(7 downto 0);

------------------------------------------------------------------------
-- Clock divider component declaration
------------------------------------------------------------------------
  component clock_manager
    port(
      clk_50   :  in  std_logic;
      clk_man  :  in  std_logic;
      sel_man  :  in  std_logic;
      clk      :  out std_logic);
  end component;

------------------------------------------------------------------------
-- Complete the remaining three component declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
  
begin  -- struct

  clock_manager1 : clock_manager
    port map (
      clk_50  => clk_50,
      clk_man => clk_man,
      sel_man => sel_man,
      clk     => clk);

------------------------------------------------------------------------
-- Complete the remaining three component instantiations
------------------------------------------------------------------------


------------------------------------------------------------------------
end struct;
