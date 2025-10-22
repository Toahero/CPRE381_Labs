library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IsZero is
    generic(
        WIDTH : integer := 32
    );
    port(
        i_Value : in std_logic_vector(WIDTH - 1 downto 0);
        o_IsZero : out std_logic := '0'
    );
end IsZero;

architecture behaviour of IsZero is

    constant ZERO : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');

begin

    o_IsZero <= '1' when (ZERO = i_Value) else '0';

end behaviour; -- behaviour
