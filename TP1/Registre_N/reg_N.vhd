library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CHECK_PKG.all ;

entity reg_N is
    GENERIC (N : INTEGER := 8);
    Port ( D : in STD_LOGIC_VECTOR (N-1 downto 0);
	   Reset : in STD_LOGIC;
	   CLK : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (N-1 downto 0));
end reg_N;

architecture archi_reg_N of reg_N is
begin
    process(CLK, reset)
    begin
	check_setup(CLK,D,5 ns);
	check_hold(CLK,D,5 ns);
	if reset='1' then
		Q<=(others=>'0');
	else
		if(CLK = '1' and CLK'event) then
			Q<=D;
		end if;
	end if;
    end process;
end archi_reg_N;
