library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sequenceur is
	port( enwrite,enread,clk, reset, req : in std_logic;
	acq, rw_n, oe, incwrite, incread, hl, selread, cs_n : out std_logic);
end sequenceur

architecture archi_Mealy of sequenceur is
type state is (state0, state1, state2, state3, state4);
signal state_attent, state_lect1, state_repo, state_ecrir, state_lect2 : state;
begin
-----------------------------------------------------------
process (clk, reset) begin --register of the memorization of the present state
	if reset = `1 the
