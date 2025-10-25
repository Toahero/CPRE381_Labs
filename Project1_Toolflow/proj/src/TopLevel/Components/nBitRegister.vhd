-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: dffg.vhd

-- nBitRegister.vhd
-------------------------------------------------------------------------
--9/10/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nBitRegister is
    generic(Reg_Size	: positive);
    port(   i_CLK  	: in std_logic;
            i_reset	: in std_logic;
            i_WrEn	: in std_logic;
            i_write	: in std_logic_vector(Reg_Size-1 downto 0);
            o_read 	: out std_logic_vector(Reg_Size-1 downto 0));

end nBitRegister;

architecture structural of nBitRegister is

	component dffg is
		port(	i_CLK	: in std_logic;
			i_RST	: in std_logic;
			i_WE	: in std_logic;
			i_D	: in std_logic;
			o_Q	: out std_logic);
	end component;
begin
	G_NBIT_REG: for i in 0 to Reg_Size-1 generate
		REG: dffg port map(
			i_CLK 	=> i_CLK,
			i_RST	=> i_reset,
			i_WE	=> i_WrEn,
			i_D	=> i_write(i),
			o_Q	=> o_read(i));
	end generate G_NBIT_REG;
end structural;	
