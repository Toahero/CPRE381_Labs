library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux4t1 is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        i_Selection : in std_logic_vector(1 downto 0);

        i_D0 : in std_logic_vector((DATA_WIDTH - 1) downto 0);
        i_D1 : in std_logic_vector((DATA_WIDTH - 1) downto 0);
        i_D2 : in std_logic_vector((DATA_WIDTH - 1) downto 0);
        i_D3 : in std_logic_vector((DATA_WIDTH - 1) downto 0);

        o_Output : out std_logic_vector((DATA_WIDTH - 1) downto 0)
    );
end Mux4t1;

architecture behaviour of Mux4t1 is
begin

    o_Output <= i_D0 when i_Selection = b"00" else
                i_D1 when i_Selection = b"01" else
                i_D2 when i_Selection = b"10" else
                i_D3 when i_Selection = b"11" else (others => '0');

end behaviour;
