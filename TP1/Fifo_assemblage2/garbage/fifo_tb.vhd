LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
USE work.FIFO_Component.all  ; 
ENTITY fifo_tb  IS 
  GENERIC (
    M  : INTEGER   := 4 ;  
    t_hold  : TIME   := 20 ns ;  
    N  : INTEGER   := 8 ;  
    t_set  : TIME   := 20 ns ); 
END ; 
 
ARCHITECTURE fifo_tb_arch OF fifo_tb IS
  SIGNAL slow_out   :  STD_LOGIC  ; 
  SIGNAL clk_In   :  STD_LOGIC  ; 
  SIGNAL Dout   :  std_logic_vector (N - 1 downto 0)  ; 
  SIGNAL fast_out   :  STD_LOGIC  ; 
  SIGNAL reset_In   :  STD_LOGIC  ; 
  SIGNAL ack_out   :  STD_LOGIC  ; 
  SIGNAL req_In   :  STD_LOGIC  ; 
  SIGNAL hl_out   :  STD_LOGIC  ; 
  SIGNAL Din   :  std_logic_vector (N - 1 downto 0)  ; 
  COMPONENT FIFO  
    GENERIC ( 
      M  : INTEGER ; 
      t_hold  : TIME ; 
      N  : INTEGER ; 
      t_set  : TIME  );  
    PORT ( 
      slow_out  : out STD_LOGIC ; 
      clk_In  : in STD_LOGIC ; 
      Dout  : out std_logic_vector (N - 1 downto 0) ; 
      fast_out  : out STD_LOGIC ; 
      reset_In  : in STD_LOGIC ; 
      ack_out  : out STD_LOGIC ; 
      req_In  : in STD_LOGIC ; 
      hl_out  : out STD_LOGIC ; 
      Din  : in std_logic_vector (N - 1 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : FIFO  
    GENERIC MAP ( 
      M  => M  ,
      t_hold  => t_hold  ,
      N  => N  ,
      t_set  => t_set   )
    PORT MAP ( 
      slow_out   => slow_out  ,
      clk_In   => clk_In  ,
      Dout   => Dout  ,
      fast_out   => fast_out  ,
      reset_In   => reset_In  ,
      ack_out   => ack_out  ,
      req_In   => req_In  ,
      hl_out   => hl_out  ,
      Din   => Din   ) ; 
END ; 

