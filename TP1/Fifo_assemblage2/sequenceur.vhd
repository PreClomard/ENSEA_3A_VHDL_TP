library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
entity sequenceur is port( 
	enwrite, enread, clk, reset, req : in std_logic; 
	acq, rw_n, oe, incwrite, incread, hl, selread, cs_n : out std_logic ); 
end sequenceur; 

architecture archi_moore_synchr of sequenceur is 
type state_type is (state0, state1, state2, state3, state4); 
signal state : state_type; 
begin 
----------------------------------------------------------- 
process (clk, reset) 
begin 
	if reset = '1' then state <= state0; 
		acq <= '1'; rw_n <= '0'; oe <= '0'; incwrite <= '0'; 
		incread <= '0'; selread <= '0'; cs_n <= '1'; hl <= '0'; 
	elsif rising_edge(clk) then 
		
		case state is 
			when state0 => 
				acq <= '1'; rw_n <= '0'; oe <= '0'; 
				incwrite <= '0'; incread <= '0'; 
				selread <= '0'; cs_n <= '1'; hl <= '0'; 
				if enread='0' and req = '0' then state <= state2; 
				elsif enread='1' then state <= state1; 
				end if; 
			when state1 => 
				acq <= '0'; rw_n <= '1'; oe <= '1'; 
				incread <= '1'; hl <= '1'; selread <= '1'; 
				cs_n <= '1'; state <= state0; 
			when state2 => 
				acq <= '0'; incwrite <= '1'; cs_n <= '0'; 
				state <= state3; 
			when state3 => 
				incwrite <= '0'; cs_n <= '1'; 
				if enread='1' and req = '0' then state <= state0; 
				elsif enread='1'  then state <= state4; 
				end if; 
			when state4 => 
				rw_n <= '1'; oe <= '1'; incread <= '1'; 
				selread <= '1'; cs_n <= '0'; 
				state <= state3; 
		end case; 
	end if; 
end process; 
end archi_moore_synchr; 

architecture archi_mealy_synchr of sequenceur is 
type state_type is (state0, state1, state2, state3, state4); 
signal state : state_type; 
begin 
----------------------------------------------------------- 
process (clk, reset) 
begin 
	if reset = '1' then state <= state0; 
		acq <= '1'; rw_n <= '0'; oe <= '0'; incwrite <= '0'; 
		incread <= '0'; selread <= '0'; cs_n <= '1'; hl <= '0'; 
	elsif rising_edge(clk) then 

		case state is 
			when state0 => 
				if enread='0'  and req = '0' then 
					state <= state2; 
					acq <= '0';incwrite <= '1';cs_n <= '0'; 
				elsif enread='1'  then 
					state <= state1; 
					rw_n <= '1'; oe <= '1';incread <= '1'; 
					hl <= '1'; selread <= '1'; cs_n <= '0'; 
				end if;
			when state1 => 
				state <= state0; 
				rw_n <= '0'; oe <= '0';incread <= '0'; hl <= '0'; 
				selread <= '0'; cs_n <= '1'; 
			when state2 => 
				state <= state3; 
				incwrite <= '0'; cs_n <= '1';
			when state3 => 
				if enread='0'  and req = '0' then 
					state <= state0; 
					acq <= '1'; cs_n <= '1'; 
				elsif enread='1'  then 
					state <= state4; 
					rw_n <= '1'; oe <= '1'; 
					incread <= '1'; selread <= '1'; cs_n <= '0'; 
				end if; 
			when state4 => 
				state <= state3; 	
				rw_n <= '0'; oe <= '0'; incread <= '0'; 
				selread <= '0'; cs_n <= '1'; 
		end case; 
	end if; 	
end process; 
end archi_mealy_synchr;
