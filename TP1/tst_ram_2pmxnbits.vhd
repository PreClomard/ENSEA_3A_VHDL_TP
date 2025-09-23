LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY tst_ram_2pmxnbits  IS 
  GENERIC (
    M  : INTEGER   := 4 ;  
    N  : INTEGER   := 8 ); 
END ; 
 
ARCHITECTURE tst_ram_2pmxnbits_arch OF tst_ram_2pmxnbits IS
  SIGNAL Dout   :  std_logic_vector (N - 1 downto 0)  ; 
  SIGNAL OE   :  STD_LOGIC  ; 
  SIGNAL RW_n   :  STD_LOGIC  ; 
  SIGNAL SC_n   :  STD_LOGIC  ; 
  SIGNAL Adr   :  std_logic_vector (M - 1 downto 0)  ; 
  SIGNAL Din   :  std_logic_vector (N - 1 downto 0)  ; 
  COMPONENT RAM_2pMxNbits  
    GENERIC ( 
      M  : INTEGER ; 
      N  : INTEGER  );  
    PORT ( 
      Dout  : out std_logic_vector (N - 1 downto 0) ; 
      OE  : in STD_LOGIC ; 
      RW_n  : in STD_LOGIC ; 
      SC_n  : in STD_LOGIC ; 
      Adr  : in std_logic_vector (M - 1 downto 0) ; 
      Din  : in std_logic_vector (N - 1 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : RAM_2pMxNbits  
    GENERIC MAP ( 
      M  => M  ,
      N  => N   )
    PORT MAP ( 
      Dout   => Dout  ,
      OE   => OE  ,
      RW_n   => RW_n  ,
      SC_n   => SC_n  ,
      Adr   => Adr  ,
      Din   => Din   ) ; 
      
  stimulus: process
    begin
        -- Activer la mémoire
        SC_n <= '0';
        OE <= '1';

        -- Écrire une valeur à l'adresse 0
        Adr <= "0000";
        Din <= "10101010";
        RW_n <= '0';
        wait for 10 ns;
        RW_n <= '1';

        -- Lire l'adresse 0
        wait for 10 ns;

        -- Vérifier la sortie
        assert Dout = "10101010" report "Test échoué : lecture incorrecte" severity error;

        -- Désactiver la mémoire
        SC_n <= '1';
        wait for 10 ns;

        -- Fin de la simulation
        wait;
    end process;
END ; 