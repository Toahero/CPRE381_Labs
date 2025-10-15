library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter is
    port(
        i_Clock : in std_logic;

        i_Opcode : in std_logic_vector(5 downto 0);
        i_Funct3 : in std_logic_vector(3 downto 0);
        i_Immediate : in std_logic_vector(31 downto 0);


        o_CurrentInstruction : out std_logic_vector(31 downto 0)
    );
end ProgramCounter;

architecture behaviour of ProgramCounter is

    constant c_ADDR_WIDTH : integer := 12;

    component InstructionAddressHolder is
        generic(
            ADDR_WIDTH : integer := 12
        );
        port(
            i_Clock : in std_logic;
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

begin

    g_InstructionAddressHolder : InstructionAddressHolder
        generic map(
            ADDR_WIDTH => c_ADDR_WIDTH
        )
        port map(
            
        );

    g_InstructionMemory : inst_mem
        generic map(
            DATA_WIDTH => 32,
            ADDR_WIDTH => c_ADDR_WIDTH
        )
        port map(
            i_clk => i_Clock,
            i_num => 
        );

end behaviour; -- behaviour
