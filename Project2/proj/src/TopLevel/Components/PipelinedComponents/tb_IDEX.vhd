entity tb_IDEX is
    generic(
        clock : time := 10 ns
    );
end tb_IDEX;

architecture mixed of tb_IDEX is

    component Buffer_IDEX is
    port(
        i_Clock                 : in  std_logic;
        i_Reset                 : in  std_logic;
        i_WriteEnable           : in  std_logic;

        i_Next                  : in  t_IFID;
        o_Current               : out t_IFID
    );
    end component;

    signal s_CLK      : std_logic;
    signal s_Reset    : std_logic;
    signal s_WrEn       : std_logic;
    signal s_currentVal    : std_logic_vector(31 downto 0);
    signal s_NextVal        : std_logic_vector(31 downto 0);


begin
    P_CLK: process
    begin
        CLK <= '1';         -- clock starts at 1
        wait for gCLK_HPER; -- after half a cycle
        CLK <= '0';         -- clock becomes a 0 (negative edge)
        wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;

P_TEST_InstructionS: process
    begin
        wait for gCLK_HPER/2; --Change inputs on clk midpoints
        
        s_nextVal <= std_logic_vector(to_unsigned(1, 31));
        wait for gCLK_HPER;
        s_nextVal <= std_logic_vector(to_unsigned(-55, 31));
        wait for gCLK_HPER;
        wait;
    end process;

end mixed;