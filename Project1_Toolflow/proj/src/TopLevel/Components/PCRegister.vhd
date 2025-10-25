library IEEE;
use IEEE.std_logic_1164.all;

-- 0 : Read
-- 1 : Write

entity PCRegister is
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
end PCRegister;

architecture behaviour of PCRegister is

    component PC_dffg is
        port(
            i_CLK        : in std_logic;     -- Clock input
            i_RST        : in std_logic;     -- Reset input
            i_RSTV       : in std_logic;     -- Reset value
            i_WE         : in std_logic;     -- Write enable input
            i_D          : in std_logic;     -- Data value input
            o_Q          : out std_logic     -- Data value output
        );
    end component;

    signal s_WriteEnabled   : std_logic := '0';
begin

    s_WriteEnabled  <= '1' when i_Operation = '1' else '0';

    generated: for i in 0 to WIDTH - 1 generate
        FlipFlop : PC_dffg
            port map(
                i_CLK   => i_Clock,
                i_RST   => i_Reset,
                i_RSTV  => i_ResetValue(i),
                
                i_WE    => s_WriteEnabled,
                i_D     => i_Data(i),

                o_Q     => o_Out(i)
            );
    
    end generate generated;
end behaviour;
