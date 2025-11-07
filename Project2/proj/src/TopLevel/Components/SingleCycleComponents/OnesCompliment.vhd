library IEEE;
use IEEE.std_logic_1164.all;

entity OnesCompliment is
    generic(
        N       : integer := 8
    );
    port(
        i_A     : in std_logic_vector(N - 1 downto 0);
        o_F     : out std_logic_vector(N - 1 downto 0)
    );
end OnesCompliment;

architecture structural of OnesCompliment is

    component invg is
        port(
            i_A : in std_logic;
            o_F : out std_logic
        );
    end component;

begin

    generated: for i in 0 to N-1 generate
        notGate: invg
            port map(
                i_A => i_A(i),
                o_F => o_F(i)
            );
    end generate generated;

end architecture;
