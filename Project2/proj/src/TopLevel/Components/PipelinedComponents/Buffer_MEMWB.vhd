library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.t_MEMWB;

entity Buffer_MEMWB is
  port(
    i_Clock                 : in  std_logic;
    i_Reset                 : in  std_logic;
    i_WriteEnable           : in  std_logic;

    i_Next                  : in  t_MEMWB;
    o_Current               : out t_MEMWB
  );
end Buffer_MEMWB;

architecture behaviour of Buffer_MEMWB is
  
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

  constant size : integer := 99;

  signal s_Next : std_logic_vector(size - 1 downto 0);
  signal s_Current : std_logic_vector(size - 1 downto 0);

begin

  

  g_Buffer : nBitRegister
      generic map(
        Reg_Size  => size
      )
      port map(
        i_CLK     => i_Clock,
        i_reset   => i_Reset,
        i_WrEn    => i_WriteEnable,
        i_write   => s_Next,
        o_read    => s_Current
      );

end behaviour;
