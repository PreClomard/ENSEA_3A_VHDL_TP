--------------------------------------------------------------------
-- genhl.vhd
-- Générateur d'horloge de lecture HL
-- Utilise le package mes_composants
-- GROUSSARD et PRESSARD
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.mes_composants.all;

entity GENHL is
  generic (
    Div : integer := 200  -- Valeur de division (200 pour 10MHz -> 50kHz)
  );
  port (
    RESET   : in  STD_LOGIC;
    CLK     : in  STD_LOGIC;
    ENREAD  : out STD_LOGIC;
    ENWRITE : out STD_LOGIC
  );
end GENHL;

architecture Behavioral of GENHL is
  -- Signaux internes
  signal counter_value  : std_logic_vector(7 downto 0);
  signal reset_counter  : std_logic;
  signal enable_counter : std_logic;


begin
  compteur_inst: DCPT_M
    generic map (
      M => 8
    )
    port map (
      ENABLE => enable_counter,
      UD     => '1',
      RESET  => reset_counter,
      CLK    => CLK,
      CPTR   => counter_value
    );

  enable_counter <= '1';
  
  reset_counter <= '1' when (RESET = '1' or unsigned(counter_value) >= Div-1) else '0';
  
  ENREAD <= reset_counter;
  
  ENWRITE <= not reset_counter;

end Behavioral;