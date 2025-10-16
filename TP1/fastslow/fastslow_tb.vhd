library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FastSlow_tb is
end FastSlow_tb;

architecture Behavioral of FastSlow_tb is
  constant CLK_PERIOD : time := 10 ns;
  constant M : integer := 4;

  signal CLK      : STD_LOGIC := '0';
  signal Incwrite : STD_LOGIC := '0';
  signal Incread  : STD_LOGIC := '0';
  signal Fast     : STD_LOGIC;
  signal Slow     : STD_LOGIC;

begin
  uut: entity work.FastSlow
    generic map (M => M)
    port map (
      CLK      => CLK,
      Incwrite => Incwrite,
      Incread  => Incread,
      Fast     => Fast,
      Slow     => Slow
    );

  -- Génération d'horloge
  CLK_process: process
  begin
    CLK <= '0';
    wait for CLK_PERIOD/2;
    CLK <= '1';
    wait for CLK_PERIOD/2;
  end process;

  -- Stimulus
  stimulus: process
  begin
    -- Incrémenter le compteur (simuler des écritures)
    Incwrite <= '1';
    wait for 100 ns;
    Incwrite <= '0';

    -- Décrémenter le compteur (simuler des lectures)
    Incread <= '1';
    wait for 100 ns;
    Incread <= '0';

    wait;
  end process;

end Behavioral;
