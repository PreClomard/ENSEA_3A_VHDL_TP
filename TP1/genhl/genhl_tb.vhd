--------------------------------------------------------------------
-- genhl_tb.vhd
-- Testbench pour le générateur d'horloge de lecture HL
-- GROUSSARD et PRESSARD
--------------------------------------------------------------------
LIBRARY ieee; 
USE ieee.NUMERIC_STD.all; 
USE ieee.std_logic_1164.all; 

ENTITY genhl_tb IS 
  GENERIC (
    Div : INTEGER := 200  -- Valeur de test (peut être réduite pour simulation)
  ); 
END genhl_tb; 
 
ARCHITECTURE genhl_tb_arch OF genhl_tb IS
  -- Signaux de test
  SIGNAL ENWRITE : STD_LOGIC; 
  SIGNAL CLK     : STD_LOGIC := '0'; 
  SIGNAL ENREAD  : STD_LOGIC; 
  SIGNAL RESET   : STD_LOGIC := '0'; 
  
  -- Constantes pour la simulation
  constant CLK_PERIOD : time := 100 ns;  -- Période d'horloge (10 MHz)
  signal sim_end : boolean := false;     -- Signal de fin de simulation
  
  -- Composant à tester
  COMPONENT GENHL  
    GENERIC ( 
      Div : INTEGER
    );  
    PORT ( 
      ENWRITE : out STD_LOGIC; 
      CLK     : in  STD_LOGIC; 
      ENREAD  : out STD_LOGIC; 
      RESET   : in  STD_LOGIC
    ); 
  END COMPONENT; 
  
BEGIN
  -- Instanciation du DUT (Device Under Test)
  DUT : GENHL  
    GENERIC MAP ( 
      Div => Div
    )
    PORT MAP ( 
      ENWRITE => ENWRITE,
      CLK     => CLK,
      ENREAD  => ENREAD,
      RESET   => RESET
    ); 
  
  -- Génération de l'horloge
  clk_process : process
  begin
    while not sim_end loop
      CLK <= '0';
      wait for CLK_PERIOD/2;
      CLK <= '1';
      wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;
  
  -- Processus de stimulation
  stimulus : process
  begin
    -- Affichage des informations de début de test
    report "========================================";
    report "Debut du test de GENHL";
    report "Valeur de Div = " & integer'image(Div);
    report "========================================";
    
    -- Test 1 : Reset initial
    report "Test 1 : Reset initial";
    RESET <= '1';
    wait for CLK_PERIOD * 3;
    RESET <= '0';
    wait for CLK_PERIOD * 2;
    
    -- Vérification que ENWRITE est actif et ENREAD inactif après reset
    assert ENWRITE = '1' 
      report "ERREUR : ENWRITE devrait etre a 1 apres reset" 
      severity error;
    assert ENREAD = '0' 
      report "ERREUR : ENREAD devrait etre a 0 apres reset" 
      severity error;
    
    -- Test 2 : Observation d'un cycle complet (200 coups d'horloge)
    report "Test 2 : Observation d'un cycle complet";
    wait for CLK_PERIOD * (Div + 5);
    
    -- Test 3 : Vérification de plusieurs cycles
    report "Test 3 : Observation de 3 cycles complets";
    wait for CLK_PERIOD * (Div * 3);
    
    -- Test 4 : Reset pendant le fonctionnement
    report "Test 4 : Reset pendant le fonctionnement";
    wait for CLK_PERIOD * 50;
    RESET <= '1';
    wait for CLK_PERIOD * 2;
    
    -- Vérification du comportement pendant reset
    assert ENWRITE = '1' or ENREAD = '0'
      report "ERREUR : Le comportement pendant reset n'est pas correct" 
      severity warning;
    
    RESET <= '0';
    wait for CLK_PERIOD * (Div + 10);
    
    -- Test 5 : Vérification finale
    report "Test 5 : Verification finale - observation de 2 cycles";
    wait for CLK_PERIOD * (Div * 2);
    
    -- Fin de simulation
    report "========================================";
    report "Fin du test de GENHL";
    report "Verifiez visuellement sur le chronogramme que :";
    report "  - ENREAD = 1 pendant 1 cycle tous les " & integer'image(Div) & " cycles";
    report "  - ENWRITE = 0 uniquement quand ENREAD = 1";
    report "  - Le compteur se remet a 0 correctement";
    report "========================================";
    
    sim_end <= true;
    wait;
  end process;
  
  -- Processus de monitoring (optionnel - pour afficher les evenements)
  monitor : process(ENREAD, ENWRITE)
  begin
    if ENREAD'event and ENREAD = '1' then
      report ">>> LECTURE activee a t=" & time'image(now);
    end if;
    if ENWRITE'event and ENWRITE = '0' then
      report ">>> ECRITURE desactivee a t=" & time'image(now);
    end if;
    if ENWRITE'event and ENWRITE = '1' then
      report ">>> ECRITURE activee a t=" & time'image(now);
    end if;
  end process;

END genhl_tb_arch;