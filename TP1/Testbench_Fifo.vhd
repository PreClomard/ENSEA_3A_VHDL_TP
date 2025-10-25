--------------------------------------------------------------------
-- FIFO_tb.vhd
-- Testbench pour la FIFO élastique
-- GROUSSARD et PRESSARD
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_tb is
end FIFO_tb;

architecture Behavioral of FIFO_tb is
  -- Constantes pour la simulation
  constant CLK_PERIOD : time := 100 ns;  -- Période d'horloge de 100 ns pour 10 MHz
  constant M : integer := 4;            -- 16 mots
  constant N : integer := 8;            -- 8 bits par mot
  constant Div : integer := 200;        -- 200 cycles pour obtenir 50 kHz à partir de 10 MHz

  -- Signaux de test
  signal CLK     : STD_LOGIC := '0';
  signal RESET   : STD_LOGIC := '0';
  signal Req     : STD_LOGIC := '0';
  signal Ack     : STD_LOGIC;
  signal Din     : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
  signal Dout    : STD_LOGIC_VECTOR(N-1 downto 0);
  signal Fast    : STD_LOGIC;
  signal Slow    : STD_LOGIC;

begin
  -- Instanciation de la FIFO
  uut: entity work.FIFO
    generic map (M => M, N => N, Div => Div)
    port map (
      CLK     => CLK,
      RESET   => RESET,
      Req     => Req,
      Ack     => Ack,
      Din     => Din,
      Dout    => Dout,
      Fast    => Fast,
      Slow    => Slow
    );

  -- Génération d'horloge
  CLK_process: process
  begin
    CLK <= '0';
    wait for CLK_PERIOD/2;
    CLK <= '1';
    wait for CLK_PERIOD/2;
  end process;

  -- Processus de stimulation
  stimulus: process
  begin
    -- Affichage des informations de début de test
    report "========================================";
    report "Début du test de la FIFO élastique";
    report "Configuration : 16 mots de 8 bits, Div = " & integer'image(Div);
    report "========================================";

    -- Réinitialisation
    RESET <= '1';
    wait for 200 ns;
    RESET <= '0';
    wait for CLK_PERIOD * 2;

    -- Écrire trois données dans la FIFO
    report "Écriture de la première donnée : 00000001";
    Din <= "00000001";  -- Donnée 1
    Req <= '1';
    wait until Ack = '0';  -- Attendre l'acquittement
    Req <= '0';
    wait for CLK_PERIOD * 2;

    report "Écriture de la deuxième donnée : 00000010";
    Din <= "00000010";  -- Donnée 2
    Req <= '1';
    wait until Ack = '0';  -- Attendre l'acquittement
    Req <= '0';
    wait for CLK_PERIOD * 2;

    report "Écriture de la troisième donnée : 00000100";
    Din <= "00000100";  -- Donnée 3
    Req <= '1';
    wait until Ack = '0';  -- Attendre l'acquittement
    Req <= '0';
    wait for CLK_PERIOD * 2;

    -- Laisser tourner la simulation pour observer les lectures
    report "Lecture des données...";
    wait for CLK_PERIOD * Div * 5;  -- Attendre suffisamment longtemps pour observer les lectures

    -- Vérification des données lues
    report "Vérification des données lues...";

    -- Fin de simulation
    report "========================================";
    report "Fin du test de la FIFO élastique";
    report "Vérifiez visuellement sur le chronogramme que :";
    report "  - Les données écrites sont correctement stockées";
    report "  - Les données lues correspondent aux données écrites";
    report "  - Les signaux Fast et Slow se comportent comme attendu";
    report "========================================";

    wait;
  end process;

  -- Processus de monitoring (optionnel - pour afficher les événements)
  monitor : process(Din, Dout, Ack, Fast, Slow)
  begin
    if Ack'event and Ack = '0' then
      report ">>> Acquittement reçu à t=" & time'image(now);
    end if;
    if Dout'event and Dout /= (Dout'high => 'Z', others => '0') then
      report ">>> Lecture de la donnée : " & to_string(Dout) & " à t=" & time'image(now);
    end if;
    if Fast'event and Fast = '1' then
      report ">>> Signal Fast activé à t=" & time'image(now);
    end if;
    if Slow'event and Slow = '1' then
      report ">>> Signal Slow activé à t=" & time'image(now);
    end if;
  end process;

  -- Fonction pour convertir un std_logic_vector en string
  function to_string(slv: STD_LOGIC_VECTOR) return string is
    variable result: string(1 to slv'length);
    variable index: integer;
  begin
    for i in slv'range loop
      index := slv'length - i + 1;
      if slv(i) = '0' then
        result(index) := '0';
      elsif slv(i) = '1' then
        result(index) := '1';
      else
        result(index) := 'X';
      end if;
    end loop;
    return result;
  end function;

end Behavioral;
