library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.t_IDEX;

entity Buffer_IDEX is
  port(
    i_Clock                 : in  std_logic;
    i_Reset                 : in  std_logic;
    i_WriteEnable           : in  std_logic;

    i_Next                  : in  t_IDEX;
    o_Current               : out t_IDEX
  );
end Buffer_IDEX;

architecture behaviour of Buffer_IDEX is

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
          Reg_Size  => t_IDEX'length
        )
        port map(
          i_CLK     => i_Clock,
          i_reset   => i_Reset,
          i_WrEn    => i_WriteEnable,
          i_write   => i_Next,
          o_read    => o_Current
        );

end behaviour;
