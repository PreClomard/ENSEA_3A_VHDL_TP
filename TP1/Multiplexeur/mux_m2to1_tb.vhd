library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX_M2to1_tb is
end MUX_M2to1_tb;

architecture Behavioral of MUX_M2to1_tb is
  constant M : integer := 4;

  -- Signaux
  signal A, B, Y : STD_LOGIC_VECTOR(M-1 downto 0) := (others => '0');
  signal SEL     : STD_LOGIC := '0';

  -- Fonction de conversion pour affichage
  function slv_to_string(slv : STD_LOGIC_VECTOR) return string is
    variable result : string(1 to slv'length);
    variable i : integer := 1;
  begin
    for idx in slv'range loop
      result(i) := std_logic'image(slv(idx))(2);
      i := i + 1;
    end loop;
    return result;
  end function;

begin

  -- Instanciation du MUX
  UUT: entity work.MUX_M2to1
    generic map(M => M)
    port map(A => A, B => B, SEL => SEL, Y => Y);

  -- Processus de test
  test_proc: process
  begin
    -- Au début du process de test
    wait for 1 ns;  -- permet la propagation initiale

    -- Test normal
    A <= "1010"; B <= "0101"; SEL <= '0';
    wait for 1 ns;
    assert Y = A severity note;  -- fonctionne correctement


    -- Test 1 : SEL = 0 -> Y = A
    A <= "0001"; B <= "1111"; SEL <= '0';
    wait for 1 ns;
    assert Y = A
      report "Test 1 FAIL : Y = " & slv_to_string(Y) & " (attendu: " & slv_to_string(A) & ")"
      severity error;
    report "Test 1 PASS" severity note;

    -- Test 2 : SEL = 1 -> Y = B
    SEL <= '1';
    wait for 1 ns;
    assert Y = B
      report "Test 2 FAIL : Y = " & slv_to_string(Y) & " (attendu: " & slv_to_string(B) & ")"
      severity error;
    report "Test 2 PASS" severity note;

    -- Test 3 : autre jeu de valeurs, SEL = 0
    A <= "1010"; B <= "0101"; SEL <= '0';
    wait for 1 ns;
    assert Y = A
      report "Test 3 FAIL : Y = " & slv_to_string(Y) & " (attendu: " & slv_to_string(A) & ")"
      severity error;
    report "Test 3 PASS" severity note;

    -- Test 4 : SEL = 1
    SEL <= '1';
    wait for 1 ns;
    assert Y = B
      report "Test 4 FAIL : Y = " & slv_to_string(Y) & " (attendu: " & slv_to_string(B) & ")"
      severity error;
    report "Test 4 PASS" severity note;

    report "Fin du testbench" severity note;
    wait;
  end process;

end Behavioral;
