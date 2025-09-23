-----------------------------------------------------------------------------
--ram_2pMxNbits
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_2pMxNbits is
    generic (
        M : integer := 4;  -- Par défaut, 2^4 = 16 mots
        N : integer := 8   -- Par défaut, 8 bits par mot
    );
    Port (
        OE      : in  STD_LOGIC;
        Din     : in  STD_LOGIC_VECTOR(N-1 downto 0);
        Adr     : in  STD_LOGIC_VECTOR(M-1 downto 0);
        RW_n    : in  STD_LOGIC;
        SC_n    : in  STD_LOGIC;
        Dout    : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end RAM_2pMxNbits;
-----------------------------------------------------------------------------
architecture Behavioral of RAM_2pMxNbits is
    type RAM_Type is array (0 to 2**M-1) of STD_LOGIC_VECTOR(N-1 downto 0);
    signal RAM : RAM_Type := (others => (others => '0'));
begin

    process(Adr, Din, RW_n, SC_n, OE)
    begin
        if SC_n = '0' then
            if RW_n = '0' then
                RAM(to_integer(unsigned(Adr))) <= Din;
            elsif RW_n = '1' and OE = '1' then
                Dout <= RAM(to_integer(unsigned(Adr)));
            else
                Dout <= (others => 'Z');
            end if;
        else
            Dout <= (others => 'Z');
        end if;
    end process;

end Behavioral;
