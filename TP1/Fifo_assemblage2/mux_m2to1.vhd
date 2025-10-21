-------------------------------------------------------------------------------------------
-- Multiplexeur M x 2 a 1
-- GROUSSARD et PRESSARD
-------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-------------------------------------------------------------------------------------------
entity MUX_M2to1 is
  generic (
    M : integer := 4  -- Taille des bus d'entrée
  );
  port (
    A   : in  STD_LOGIC_VECTOR(M-1 downto 0);
    B   : in  STD_LOGIC_VECTOR(M-1 downto 0);
    SEL : in  STD_LOGIC;
    Y   : out STD_LOGIC_VECTOR(M-1 downto 0)
  );
end MUX_M2to1;

architecture Behavioral of MUX_M2to1 is
begin
  Y <= A when SEL = '0' else B;
end Behavioral;

