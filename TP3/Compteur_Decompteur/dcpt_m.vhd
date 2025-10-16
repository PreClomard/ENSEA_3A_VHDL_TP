-------------------------------------------------------------------------------------------
-- Compteur/Décompteur M bits
-- GROUSSARD et PRESSARD
-------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-------------------------------------------------------------------------------------------
entity DCPT_M is
  generic (
    M : integer := 8  -- Nombre de bits du compteur/décompteur
  );
  port (
    ENABLE : in  STD_LOGIC;  -- Active le comptage/décomptage
    UD     : in  STD_LOGIC;  -- '1' pour compter, '0' pour décompter
    RESET  : in  STD_LOGIC;  -- Reset synchrone
    CLK    : in  STD_LOGIC;  -- Horloge
    CPTR   : out STD_LOGIC_VECTOR(M-1 downto 0)  -- Sortie du compteur/décompteur
  );
end DCPT_M;
-------------------------------------------------------------------------------------------
architecture Behavioral of DCPT_M is
  signal counter : std_logic_vector(M-1 downto 0) := (others => '0');
begin
  process(CLK)
  begin
    if rising_edge(CLK) then
      if RESET = '1' then
        counter <= (others => '0');
      elsif ENABLE = '1' then
        if UD = '1' then
          -- Mode compteur
          
            counter <= counter + '1';
         
        else
          -- Mode décompteur
          
            counter <= counter - '1';
          end if;
        end if;
      end if;

  end process;
  CPTR <= counter;
end Behavioral;
