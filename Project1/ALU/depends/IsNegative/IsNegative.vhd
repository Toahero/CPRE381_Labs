library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity IsNegative is
    generic(
        WIDTH           : integer := 32
    );
    port(
        i_Value         : in std_logic_vector(WIDTH - 1 downto 0);
        o_IsNegative    : out std_logic
    );
end IsNegative;

architecture behaviour of IsNegative is
begin

    o_IsNegative <= i_Value(WIDTH - 1);

end behaviour; -- behaviour
