--------------------------------------------------------------------
-- mon_package.vhd
-- Package contenant les declarations des fonctions, procedures et composants
-- GROUSSARD et PRESSARD
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package mon_package is
  -- Fonction pour le complement_a_2
  function cpl2 (entree: std_logic_vector; N: natural) return std_logic_vector;

  -- Declaration de la procedure check_setup
  procedure check_setup(
    signal clk: in std_logic;
    signal din: in std_logic_vector;
    t_setup: in time;
    severite: in severity_level := warning;
    hdeb: in time := time'low;
    hfin: in time := time'high);

  -- Declaration de la procedure check_hold
  procedure check_hold(
    signal clk: in std_logic;
    signal din: in std_logic_vector;
    t_hold: in time;
    severite: in severity_level := warning;
    hdeb: in time := time'low;
    hfin: in time := time'high);

  -- Declaration du composant DCPT_M (Compteur/Decompteur M bits)
  component DCPT_M
    generic (
      M : integer := 8
    );
    port (
      ENABLE : in  STD_LOGIC; 
      UD     : in  STD_LOGIC; 
      RESET  : in  STD_LOGIC; 
      CLK    : in  STD_LOGIC; 
      CPTR   : out STD_LOGIC_VECTOR(M-1 downto 0) 
    );
  end component;

  -- Declaration du composant GENHL (Generateur d'horloge de lecture)
  component GENHL
    generic (
      Div : integer := 200  -- Valeur de division
    );
    port (
      RESET   : in  STD_LOGIC;
      CLK     : in  STD_LOGIC;
      ENREAD  : out STD_LOGIC;
      ENWRITE : out STD_LOGIC
    );
  end component;

  -- Declaration du composant RAM
  component RAM
    generic (
      M : integer := 4;  
      N : integer := 8  
    );
    port (
      CS_n  : in  STD_LOGIC; 
      RW_n  : in  STD_LOGIC; 
      OE    : in  STD_LOGIC;  
      Adr   : in  STD_LOGIC_VECTOR(M-1 downto 0);
      Din   : in  STD_LOGIC_VECTOR(N-1 downto 0);
      Dout  : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
  end component;

  -- Declaration du composant MUX_M2to1 (Multiplexeur M x 2 vers 1)
component MUX_M2to1
  generic (
    M : integer := 4  -- Taille des bus d'entrée
  );
  port (
    A   : in  STD_LOGIC_VECTOR(M-1 downto 0);
    B   : in  STD_LOGIC_VECTOR(M-1 downto 0);
    SEL : in  STD_LOGIC;
    Y   : out STD_LOGIC_VECTOR(M-1 downto 0)
  );
end component;

  -- Declaration du composant GENADR (Generateur d'adresse)
  component GENADR
    generic (
      M : integer := 4 
    );
    port (
      RESET    : in  STD_LOGIC;
      CLK      : in  STD_LOGIC;
      incread  : in  STD_LOGIC;
      incwrite : in  STD_LOGIC;
      selread  : in  STD_LOGIC;
      Adrg     : out STD_LOGIC_VECTOR(M-1 downto 0)
    );
  end component;

  -- Declaration du composant FASTSLOW
  component FASTSLOW
    generic (
      M : integer := 4
    );
    port (
      RESET    : in  STD_LOGIC;
      CLK      : in  STD_LOGIC;
      incread  : in  STD_LOGIC;
      incwrite : in  STD_LOGIC;
      fast     : out STD_LOGIC;
      slow     : out STD_LOGIC
    );
  end component;

  -- Declaration du composant complement_a_2
  component complement_a_2
    generic (
      N : natural := 8
    );
    port (
      nombre : in  std_logic_vector(N-1 downto 0);
      sortie : out std_logic_vector(N-1 downto 0)
    );
  end component;

  -- Declaration du composant Reg_N (Registre N bits)
  component Reg_N
    generic (
      N : integer := 8
    );
    port (
      RESET : in  STD_LOGIC;
      CLK   : in  STD_LOGIC;
      D     : in  STD_LOGIC_VECTOR(N-1 downto 0);
      Q     : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
  end component;

end package mon_package;

--------------------------------------------------------------------
-- Corps du package mon_package
--------------------------------------------------------------------
package body mon_package is

  -- Implementation de la fonction cpl2
  function cpl2 (entree: std_logic_vector; N: natural) return std_logic_vector is
    variable temp: std_logic_vector(N-1 downto 0);
  begin
    temp := not entree;
    temp := temp + '1';
    return temp;
  end cpl2;

  -- Implementation de la procedure check_setup
  procedure check_setup(
    signal clk: in std_logic;
    signal din: in std_logic_vector;
    t_setup: in time;
    severite: in severity_level := warning;
    hdeb: in time := time'low;
    hfin: in time := time'high) is
  begin
    loop
      wait on clk;
      if clk = '1' and clk'event then
        if now >= hdeb and now <= hfin then
          assert din'last_event >= t_setup and din'event = false
          report "temps de setup non respecte" severity severite;
        elsif now > hfin then
          wait;
        end if;
      end if;
    end loop;
  end check_setup;

  -- Implementation de la procedure check_hold
  procedure check_hold(
    signal clk: in std_logic;
    signal din: in std_logic_vector;
    t_hold: in time;
    severite: in severity_level := warning;
    hdeb: in time := time'low;
    hfin: in time := time'high) is
    variable t: time;
  begin
    loop
      wait until clk='1';
      t := now;
      if t >= hdeb and t <= hfin then
        if din'event = false then
          wait on din for t_hold;
        end if;
        assert din'event = false or (now - t) = t_hold
        report "temps de hold non respecte" severity severite;
      elsif t > hfin then
        wait; -- suspension definitive
      end if;
    end loop;
  end check_hold;

end package body mon_package;
