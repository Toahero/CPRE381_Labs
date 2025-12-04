library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.RISCV_types.t_IFID;

entity Buffer_IFID is
  port(
    i_Clock                 : in  std_logic;
    i_Reset                 : in  std_logic;
    i_WriteEnable           : in  std_logic;
    i_NOP                   : in  std_logic;

    i_Next                  : in  t_IFID;
    o_Current               : out t_IFID
  );
end Buffer_IFID;

architecture behaviour of Buffer_IFID is

  component PCRegister is
    generic(
      WIDTH        : integer := 5
    );
    port(
      i_Clock      : in std_logic;
  
      i_Data       : in std_logic_vector(WIDTH - 1 downto 0);
      i_Operation  : in std_logic;
      i_Reset      : in std_logic;
      i_ResetValue : in std_logic_vector(WIDTH - 1 downto 0);
  
      o_Out        : out std_logic_vector(WIDTH - 1 downto 0)
    );
  end component;


  constant size : integer := 64;

  signal s_Next : std_logic_vector(size - 1 downto 0);
  signal s_Current : std_logic_vector(size - 1 downto 0);

  signal s_ResetValue : std_logic_vector(size - 1 downto 0);

begin

  s_ResetValue <= x"0000000000000000";

  s_Next <= (
    i_Next.Instruction &
    i_Next.ProgramCounter
  );

  o_Current.Instruction     <= x"00000013" when i_NOP = '1' else s_Current(63 downto 32);
  o_Current.ProgramCounter  <= x"00000000" when i_NOP = '1' else s_Current(31 downto 0 );

  g_Buffer : PCRegister
    generic map(
      WIDTH     => size
    )
    port map(
      i_Clock       => i_Clock,
      i_Reset       => i_Reset or i_NOP,
      i_Operation   => i_WriteEnable,
      i_Data        => s_Next,
      i_ResetValue  => s_ResetValue,
      o_Out         => s_Current
    );

end behaviour;
