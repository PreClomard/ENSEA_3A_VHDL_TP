-------------------------------------------------------------------------------------------
-- Generateur d'adresse
-- GROUSSARD et PRESSARD
-------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.mon_package.all;
-------------------------------------------------------------------------------------------
entity GenAdr is
  generic (
    M : integer := 4
  );
  port (
    CLK      : in  STD_LOGIC;
    RESET    : in  STD_LOGIC;
    Incwrite : in  STD_LOGIC;
    Incread  : in  STD_LOGIC;
    Selread  : in  STD_LOGIC;
    Adrg      : out STD_LOGIC_VECTOR(M-1 downto 0)
  );
end GenAdr;
-------------------------------------------------------------------------------------------
architecture Behavioral of GenAdr is
  signal write_counter : STD_LOGIC_VECTOR(M-1 downto 0) := (others => '0');
  signal read_counter  : STD_LOGIC_VECTOR(M-1 downto 0) := (others => '0');

begin
  -- Compteur pour les adresses d'ecriture
  write_counter_inst: DCPT_M
    generic map (M => M)
    port map (
      ENABLE => incwrite,
      UD     => '1',  -- Toujours en mode compteur
      RESET  => RESET,
      CLK    => CLK,
      CPTR   => write_counter
    );

  -- Compteur pour les adresses de lecture
  read_counter_inst: DCPT_M
    generic map (M => M)
    port map (
      ENABLE => incread,
      UD     => '1',  -- Toujours en mode compteur
      RESET  => RESET,
      CLK    => CLK,
      CPTR   => read_counter
    );

  -- Multiplexeur pour selectionner l'adresse
  mux_inst: MUX_M2to1
    generic map (M => M)
    port map (
      A   => write_counter,
      B   => read_counter,
      SEL => selread,
      Y   => Adrg
    );

end Behavioral;
