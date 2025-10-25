library IEEE;
use IEEE.std_logic_1164.all;

entity BitExtender is
    generic(
        INPUT_WIDTH : integer := 12;
        OUTPUT_WIDTH : integer := 32
    );
    port(
        f_SignExtend : in std_logic;
        i_Input : in std_logic_vector(INPUT_WIDTH - 1 downto 0);
        o_Output : out std_logic_vector(OUTPUT_WIDTH - 1 downto 0)
    );
end BitExtender;

architecture behaviour of BitExtender is
    signal s_Extension : std_logic_vector((OUTPUT_WIDTH - INPUT_WIDTH - 1) downto 0);
begin

    s_Extension <= (others => (i_Input(INPUT_WIDTH - 1) and f_SignExtend));

    o_Output <= s_Extension & i_Input;

end behaviour;