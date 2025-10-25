library ieee;
use ieee.std_logic_1164.all;

entity HACK is
    port (
        input_vec  : in  std_logic_vector(31 downto 0);
        output_vec : out std_logic_vector(31 downto 0)
    );
end entity HACK;

architecture structural of HACK is
begin

    gen_bits : for i in 0 to 31 generate
    
        output_vec(i) <= '0' when input_vec(i) = '0' else '1';

    end generate gen_bits;

end architecture structural;
