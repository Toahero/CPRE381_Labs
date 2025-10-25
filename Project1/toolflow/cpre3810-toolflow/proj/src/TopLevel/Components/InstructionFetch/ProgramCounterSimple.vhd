-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: mux2t1N
--Description: N bit and gate

--
-------------------------------------------------------------------------
--10/18/25 by JAG: Initially Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity ProgramCounterSimple is
    generic(ADD_SIZE	: positive);
    port(   i_CLK  	: in std_logic;
            i_RST	: in std_logic;
            i_halt	: in std_logic;
            i_nextInst	: in std_logic_vector(ADD_SIZE-1 downto 0);
            o_CurrInst 	: out std_logic_vector(ADD_SIZE-1 downto 0));

end ProgramCounterSimple;

architecture mixed of ProgramCounterSimple is
    
    component PC_nBitRegister is
        generic(Reg_Size	: positive);
        port(   
            i_CLK  	: in std_logic;
            i_reset	: in std_logic;
            i_WrEn	: in std_logic;
            i_write	: in std_logic_vector(Reg_Size-1 downto 0);
            o_read 	: out std_logic_vector(Reg_Size-1 downto 0)
        );
    
    end component;

    signal s_NotHalt: std_logic;
begin
    s_NotHalt <= not i_halt;

    o_CurrInst <= x"00000000";

    PC_REG: PC_nBitRegister
        generic map(Reg_Size => ADD_SIZE)
        port map(   i_CLK   => i_CLK,
                    i_reset => i_RST,
                    i_WrEn  => s_NotHalt,
                    i_write => i_NextInst,
                    o_read  => open);

end mixed;
