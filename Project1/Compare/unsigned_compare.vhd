library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UnsignedLessThan is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        i_A     : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        i_B     : in std_logic_vector(DATA_WIDTH - 1 downto 0);

        o_AisLessThanB : out std_logic
    );
end UnsignedLessThan;

architecture behaviour of UnsignedLessThan is

    signal s_XOR_AB : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

    s_XOR_AB <= i_A XOR i_B;

    

end behaviour;
