library IEEE;
use IEEE.std_logic_1164.all;

entity Buffer_IFID is
  port(
    i_Clock             : in std_logic;
    i_Reset             : in std_logic;
    i_WriteEnable       : in std_logic := '1';
    i_NextPCValue       : in std_logic_vector(31 downto 0);
    i_NextInstruction   : in std_logic_vector(31 downto 0);

    o_NextPCValue       : out std_logic_vector(31 downto 0);
    o_NextInstruction   : out std_logic_vector(31 downto 0)
  );
end Buffer_IFID;

architecture behaviour of Buffer_IF is
  component nBitRegister is
      generic(
        Reg_Size    : positive
      );
      port(
        i_CLK  	    : in  std_logic;
        i_reset	    : in  std_logic;
        i_WrEn	    : in  std_logic;
        i_write	    : in  std_logic_vector(Reg_Size - 1 downto 0);
        o_read 	    : out std_logic_vector(Reg_Size - 1 downto 0)
      );
  end component;
begin

    g_Buffer : nBitRegister
        generic map(

        )
        port map(

        );

end behaviour;
