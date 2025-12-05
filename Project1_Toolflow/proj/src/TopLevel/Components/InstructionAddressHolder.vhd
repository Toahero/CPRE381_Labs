library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Author : Andy Eslick
-- The current instruction is held in a register,
-- with reset tied to 0 and operation tied to write.

entity InstructionAddressHolder is
    generic(
        ADDR_WIDTH : integer := 32
    );
    port(
        i_Clock : in std_logic;
        i_Reset : in std_logic;
        i_NextInstructionAddress : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
        i_Halt : in std_logic;

        o_CurrentInstructionAddress : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
    );
end InstructionAddressHolder;

architecture behaviour of InstructionAddressHolder is

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

    signal s_ResetValue : std_logic_vector(ADDR_WIDTH - 1 downto 0) := x"00400000";

    signal s_Halted : std_logic := '0';
    signal s_notHalted : std_logic := '1';
    
begin

    s_Halted    <= 
                    '1' when    i_Halt = '1' or s_Halted = '1' else
                    '0' when    i_Halt = '0' else
                    '0';
    
    s_notHalted <= not s_Halted;

    g_PCRegister : PCRegister
        generic map(
            WIDTH => ADDR_WIDTH
        )
        port map(
            i_Clock => i_Clock,
            i_Operation => s_notHalted,
            i_Reset => i_Reset,
            i_ResetValue => s_ResetValue,

            i_Data => i_NextInstructionAddress,
            o_Out => o_CurrentInstructionAddress
        );

end behaviour;
