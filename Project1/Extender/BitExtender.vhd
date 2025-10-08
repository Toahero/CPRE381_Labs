library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BitExtender is
    generic(
        INPUT_WIDTH : integer := 20;
    );
    port(
        i_Input : std_logic_vector(INPUT_WIDTH - 1 downto 0);
        
    );
end BitExtender;

architecture behaviour of BitExtender is
begin



end behaviour ; -- behaviour
