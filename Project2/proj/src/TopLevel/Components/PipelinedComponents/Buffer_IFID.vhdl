library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.t_IFID;

entity Buffer_IFID is
  port(
    i_Clock             : in std_logic;
    i_Reset             : in std_logic;
    i_WriteEnable       : in std_logic := '1';

    i_NextPCValue       : in std_logic_vector(31 downto 0);
    i_NextInstruction   : in std_logic_vector(31 downto 0);

    o_CurrentPCValue       : out std_logic_vector(31 downto 0);
    o_CurrentInstruction   : out std_logic_vector(31 downto 0)
  );
end Buffer_IFID;

architecture behaviour of Buffer_IFID is
  
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

  signal s_RegisterIn   : std_logic_vector(63 downto 0) := x"0000000000000000";
  signal s_RegisterOut  : std_logic_vector(63 downto 0) := x"0000000000000000";

begin

  -- Upper bits are Program Counter Value
  -- Lower bits are Instruction

  s_RegisterIn          <= (i_NextPCValue & i_NextInstruction);

  o_CurrentPCValue      <= s_RegisterOut(63 downto 32);
  o_CurrentInstruction  <= s_RegisterOut(31 downto 0 );

  g_Buffer : nBitRegister
      generic map(
        Reg_Size  => (32 + 32)
      )
      port map(
        i_CLK     => i_Clock,
        i_reset   => i_Reset,
        i_WrEn    => i_WriteEnable,
        i_write   => s_RegisterIn,
        o_read    => s_RegisterOut
      );

end behaviour;
