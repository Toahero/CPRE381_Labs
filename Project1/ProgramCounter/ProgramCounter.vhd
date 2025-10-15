library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstructionHolder is
    port(
        i_Clock : in std_logic;
        i_NextInstruction : in std_logic_vector(31 downto 0);

        o_CurrentInstruction : out std_logic_vector(31 downto 0)
    );
end InstructionHolder;

architecture behaviour of InstructionHolder is

    component GenericRegister is
        generic(
            WIDTH       : integer := 32
        );
        port(
            i_Clock     : in std_logic;

            i_Data      : in std_logic_vector(WIDTH - 1 downto 0);
            i_Operation : in std_logic;
            i_Reset     : in std_logic;

            o_Out       : out std_logic_vector(WIDTH - 1 downto 0)
        );
    end component;

begin

    g_InstructionCoordiantor : GenericRegister
        generic map(
            WIDTH => 32
        )
        port map(
            i_Clock => i_Clock,

            i_Data => i_NextInstruction,
            i_Operation => 
            i_Reset => '0',

            o_Out => o_CurrentInstruction
        );

end behaviour; -- behaviour
