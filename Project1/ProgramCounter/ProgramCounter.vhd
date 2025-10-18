library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter is
    generic(
        INST_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 12
    );
    port(
        i_Clock : in std_logic;
        i_Reset : in std_logic;

        i_Opcode : in std_logic_vector(5 downto 0);
        i_Funct3 : in std_logic_vector(2 downto 0);
        i_Immediate : in std_logic_vector(31 downto 0);

        o_CurrentInstruction : out std_logic_vector((INST_WIDTH - 1) downto 0)
    );
end ProgramCounter;

architecture behaviour of ProgramCounter is

    component InstructionAddressHolder is
        generic(
            ADDR_WIDTH : integer := 12
        );
        port(
            i_Clock : in std_logic;
            i_Reset : in std_logic;
            i_NextInstructionAddress : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
    
            o_CurrentInstructionAddress : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
        );
    end component;

    component inst_mem is
        generic(
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );
    
        port(
            i_clk   : in std_logic;
            i_num   : in std_logic_vector((ADDR_WIDTH-1) downto 0);
            o_inst  : out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    end component;

    component addSub_n is
        generic(
            Comp_Width : integer -- Generic of type integer for input/output data width.
        );
        port(
            nAdd_Sub	: in std_logic;
            i_A		    : in std_logic_vector(Comp_Width-1 downto 0);
            i_B		    : in std_logic_vector(Comp_Width-1 downto 0);
            o_overflow	: out std_logic;
            o_Sum		: out std_logic_vector(Comp_Width-1 downto 0)
        );
    end component;

    signal s_CurrentInstructionAddr : std_logic_vector((ADDR_WIDTH - 1) downto 0);
    signal s_NextInstructionAddr    : std_logic_vector((ADDR_WIDTH - 1) downto 0);

begin

    g_InstructionAddressHolder : InstructionAddressHolder
        generic map(
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map(
            i_Clock => i_Clock,
            i_Reset => i_Reset,
            i_NextInstructionAddress => s_NextInstructionAddr,
            o_CurrentInstructionAddress => s_CurrentInstructionAddr
        );

    g_InstructionMemory : inst_mem
        generic map(
            DATA_WIDTH => INST_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map(
            i_clk => i_Clock,
            i_num => s_CurrentInstructionAddr,
            o_inst => o_CurrentInstruction
        );

    g_NoBranchAdder : addSub_n
        generic map(
            Comp_Width  => ADDR_WIDTH
        )
        port map(
            nAdd_Sub	=> '0',
            i_A		    => s_CurrentInstructionAddr,
            i_B		    => std_logic_vector(to_unsigned(4, ADDR_WIDTH)),
            o_overflow	=> open,
            o_Sum		=> s_NextInstructionAddr
        );

end behaviour; -- behaviour
