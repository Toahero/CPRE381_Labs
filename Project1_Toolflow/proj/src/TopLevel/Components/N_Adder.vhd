library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;

entity N_Adder is
    generic(
        D_WIDTH : integer := 8
    );
    port(
        i_C : in std_logic;
        i_A : in std_logic_vector(D_WIDTH - 1 downto 0);
        i_B : in std_logic_vector(D_WIDTH - 1 downto 0);

        o_S : out std_logic_vector(D_WIDTH - 1 downto 0);
        o_C : out std_logic
    );
end N_Adder;

architecture behaviour of N_Adder is

    component FullAdder is
        port(
            i_A : in std_logic;
            i_B : in std_logic;
            i_C : in std_logic;

            o_S : out std_logic;
            o_C : out std_logic
        );
    end component;

    signal s_InternalCarry : std_logic_vector(D_WIDTH downto 0);

begin

    s_InternalCarry(0) <= i_C;

    generated: for i in 0 to D_WIDTH - 1 generate

        Adder : FullAdder
            port map(
                i_A => i_A(i),
                i_B => i_B(i),
                i_C => s_InternalCarry(i),

                o_S => o_S(i),
                o_C => s_InternalCarry(i + 1)
            );

    end generate generated;

    o_C <= s_InternalCarry(D_WIDTH);

end behaviour ; -- behaviour
