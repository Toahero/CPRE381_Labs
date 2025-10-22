library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Compare is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        i_A         : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        i_B         : in std_logic_vector(DATA_WIDTH - 1 downto 0);

        f_Unsigned  : in std_logic;

        o_Result    : in std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end Compare;

architecture behaviour of Compare is

    

begin



end behaviour;
