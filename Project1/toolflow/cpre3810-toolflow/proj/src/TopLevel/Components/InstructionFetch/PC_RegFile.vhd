library IEEE;
use IEEE.std_logic_1164.all;

entity PC_nBitRegister is
    generic(Reg_Size	: positive);
    port(   
        i_CLK  	: in std_logic;
        i_reset	: in std_logic;
        i_WrEn	: in std_logic;
        i_write	: in std_logic_vector(Reg_Size-1 downto 0);
        o_read 	: out std_logic_vector(Reg_Size-1 downto 0)
    );

end PC_nBitRegister;

architecture structural of PC_nBitRegister is

    component PC_dffg is
        port(
            i_CLK        : in  std_logic;     -- Clock input
            i_RST        : in  std_logic;     -- Reset input
            i_WE         : in  std_logic;     -- Write enable input
            i_D          : in  std_logic;     -- Data value input
            i_RstVal     : in  std_logic;
            o_Q          : out std_logic        -- Data value output
        );
    end component;

    signal s_ResetValue : std_logic_vector(Reg_Size - 1 downto 0) := x"00000000";

begin
	G_NBIT_REG: for i in 0 to Reg_Size-1 generate
		REG: PC_dffg port map(
			i_CLK 	=> i_CLK,
			i_RST	=> i_reset,
			i_WE	=> i_WrEn,
			i_D	=> i_write(i),
            i_RstVal => s_ResetValue(i),
			o_Q	=> o_read(i));
	end generate G_NBIT_REG;
end structural;
