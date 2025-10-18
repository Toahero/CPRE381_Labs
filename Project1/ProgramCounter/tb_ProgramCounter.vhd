library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ProgramCounter is
    generic(
        clock : time := 10 ns
    );
end tb_ProgramCounter;

architecture behaviour of tb_ProgramCounter is

    component ProgramCounter is
        generic(
            INST_WIDTH : integer := 32;
            ADDR_WIDTH : integer := 12
        );
        port(
            i_Clock : in std_logic;
            i_Reset : in std_logic;
            i_Opcode : in std_logic_vector(5 downto 0);
            i_Funct3 : in std_logic_vector(3 downto 0);
            i_Immediate : in std_logic_vector(31 downto 0);
            o_CurrentInstruction : out std_logic_vector((INST_WIDTH - 1) downto 0)
        );
    end component;    

    signal s_iClock : std_logic;
    signal s_iReset : std_logic;
    signal s_iOpcode : std_logic_vector(5 downto 0);
    signal s_iFunct3 : std_logic_vector(3 downto 0);
    signal s_iImmediate : std_logic_vector((32 - 1) downto 0);
    signal s_oCurrentInstruction : std_logic_vector((32 - 1) downto 0);

begin

    p_clock : process
    begin
        wait for (clock / 4);
        s_iClock <= '0';

        wait for (clock / 4);
        s_iClock <= '1';
    end process;

    testbench : ProgramCounter
        generic map(
            INST_WIDTH => 32,
            ADDR_WIDTH => 12
        )
        port map(
            i_Clock => s_iClock,
            i_Reset => s_iReset,
            i_Opcode => s_iOpcode,
            i_Funct3 => s_iFunct3,
            i_Immediate => s_iImmediate,
            o_CurrentInstruction  => s_oCurrentInstruction
        );

    tests : process
    begin
        wait for (clock / 2);
        s_iReset <= '1';
        wait for clock;
        s_iReset <= '0';
        wait;
    end process;

end behaviour;
