
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.FIFO_Component.all;

entity FIFO is
  GENERIC (N : INTEGER := 8; 
	   M : INTEGER := 4;
	   t_set: TIME := 20 ns; 
	   t_hold : TIME := 20 ns);

  Port ( Din : in STD_LOGIC_VECTOR (N-1 downto 0);
	 Dout : out STD_LOGIC_VECTOR (N-1 downto 0);
	 reset_In, clk_In, req_In : in STD_LOGIC;
	 ack_out, hl_out, fast_out, slow_out : out STD_LOGIC
	
	);
end entity;

architecture structure of FIFO is 
  signal Reg_out, Comp2_out : STD_LOGIC_VECTOR (N-1 downto 0);
  signal enread_out, enwrite_out: STD_LOGIC;
  signal  rw_n_out, oe_out, incwrite_out, incread_out, selread_out, cs_n_out : STD_LOGIC;
  signal Adrg_out : STD_LOGIC_VECTOR(M-1 downto 0) ;
  begin 

     -- Instanciation de RegN
     U1: reg_N
	port map(
	  Reset => reset_In,
	  CLK => clk_In,
	  D => Din,
	  --Sortie
	  Q => Reg_out
	);

     -- Instanciation de Complement a 2
     U2: complement_a_2
	port map(
	  nombre => Reg_out,
	  --Sortie
	  sortie => Comp2_out
	);

     -- Instanciation de Genhl
     U3: GENHL 
	port map(
	  RESET => reset_In,	
	  CLK => clk_In,
	  --Sortie
	  ENREAD => enread_out,
	  ENWRITE => enwrite_out
	);
	
     -- Instanciation de Seq
     U4: sequenceur
	port map(
	  CLK => clk_In,
	  reset => reset_In,
	  enread => enread_out,
	  enwrite => enwrite_out,
	  req => req_In,
	  --Sortie
	  acq => ack_out, 
	  rw_n => rw_n_out, 
	  oe => oe_out, 
	  incwrite => incwrite_out,
	  incread => incread_out, 
	  hl => hl_out, 
	  selread => selread_out, 
	  cs_n => cs_n_out
	);
	
     -- Instanciation de FastSlow
     U5: FASTSLOW
	port map(
	  RESET => reset_In,	
	  CLK => clk_In,
	  incwrite => incwrite_out,
	  incread => incread_out, 
	  --Sortie
	  fast => fast_out, 
	  slow => slow_out 
	);

      -- Instanciation de Ram
      U6: GENADR
	port map(
	  RESET => reset_In,	
	  CLK => clk_In,
	  incwrite => incwrite_out,
	  incread => incread_out, 
	  selread => selread_out,
	  --Sortie
	  Adrg => Adrg_out
	);

      -- Instanciation de Ram
      U7: RAM
	port map(
	  CS_n => cs_n_out,
	  RW_n => rw_n_out,
	  OE => oe_out,
	  Adr => Adrg_out,
	  Din => Comp2_out,
	  --Sortie
	  Dout => Dout
	);

end architecture;
    
	 
  