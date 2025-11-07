library IEEE;
use IEEE.std_logic_1164.all;

entity Buffer_IDEX is
  port(
    i_Clock                 : in  std_logic;
    i_Reset                 : in  std_logic;
    i_WriteEnable           : in  std_logic;

    i_NextWriteBack         : in  std_logic;
    i_NextMemory            : in  std_logic;
    i_NextExecute           : in  std_logic;
    i_NextRS1Address        : in  std_logic_vector(4  downto 0);
    i_NextRS2Address        : in  std_logic_vector(4  downto 0);
    i_NextRS1Value          : in  std_logic_vector(31 downto 0);
    i_NextRS2Value          : in  std_logic_vector(31 downto 0);
    i_NextImmediateGen      : in  std_logic_vector(31 downto 0);


    o_CurrentWriteBack      : out std_logic;
    o_CurrentMemory         : out std_logic;
    o_CurrentExecute        : out std_logic;
    o_CurrentRS1Address     : out std_logic_vector(4  downto 0);
    o_CurrentRS2Address     : out std_logic_vector(4  downto 0);
    o_CurrentRS1Value       : out std_logic_vector(31 downto 0);
    o_CurrentRS2Value       : out std_logic_vector(31 downto 0);
    o_CurrentImmediateGen   : out std_logic_vector(31 downto 0)

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

  signal s_RegisterIn   : std_logic_vector(108 downto 0) := (others => '0');
  signal s_RegisterOut  : std_logic_vector(108 downto 0) := (others => '0');

begin
  
    s_RegisterIn      <= (
      i_NextWriteBack       &
      i_NextMemory          &
      i_NextExecute         &
      i_NextRS1Address      &
      i_NextRS2Address      &
      i_NextRS1Value        &
      i_NextRS2Value        &
      i_NextImmediateGen  
    );

    o_CurrentWriteBack      <= s_RegisterOut(108);
    o_CurrentMemory         <= s_RegisterOut(107);
    o_CurrentExecute        <= s_RegisterOut(106);
    o_CurrentRS1Address     <= s_RegisterOut(105 downto 101);
    o_CurrentRS2Address     <= s_RegisterOut(100 downto 96 );
    o_CurrentRS1Value       <= s_RegisterOut(95  downto 64 );
    o_CurrentRS2Value       <= s_RegisterOut(63  downto 32 );
    o_CurrentImmediateGen   <= s_RegisterOut(31  downto 0  );

    g_Buffer : nBitRegister
        generic map(
          Reg_Size  => 109
        )
        port map(
          i_CLK     => i_Clock,
          i_reset   => i_Reset,
          i_WrEn    => i_WriteEnable,
          i_write   => s_RegisterIn,
          o_read    => s_RegisterOut
        );

end behaviour;
