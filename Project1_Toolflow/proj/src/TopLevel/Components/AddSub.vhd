library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;

entity AddSub is
    generic(
        WIDTH : integer := 8
    );
    port(
        i_A : in std_logic_vector(WIDTH - 1 downto 0);
        i_B : in std_logic_vector(WIDTH - 1 downto 0);
        n_Add_Sub : in std_logic;

        o_S : out std_logic_vector(WIDTH - 1 downto 0);
        o_C : out std_logic
    );
end AddSub;

architecture behaviour of AddSub is

    component N_Adder is
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
    end component;

    component OnesCompliment is
        generic(
            N       : integer := 8
        );
        port(
            i_A     : in std_logic_vector(N - 1 downto 0);
            o_F     : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component mux2t1_N is
        generic(
            N : integer := 16
        );
        port(
            i_S          : in std_logic;
            i_D0         : in std_logic_vector(N-1 downto 0);
            i_D1         : in std_logic_vector(N-1 downto 0);
            o_O          : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal s_NotB : std_logic_vector(WIDTH - 1 downto 0);
    signal s_ResultB : std_logic_vector(WIDTH - 1 downto 0);

begin

    g_InvertB : OnesCompliment
        generic map(
            N => WIDTH
        )
        port map(
            i_A => i_B,
            o_F => s_NotB
        );

    g_SubtractionMux : mux2t1_N
        generic map(
            N       => WIDTH
        )
        port map(
            i_S     => n_Add_Sub,
            i_D0    => i_B,
            i_D1    => s_NotB,
            o_O     => s_ResultB
        );

    g_Adder : N_Adder
        generic map(
            D_WIDTH => WIDTH
        )
        port map(
            i_A => i_A,
            i_B => s_ResultB,
            i_C => n_Add_Sub,

            o_C => o_C,
            o_S => o_S
        );

end behaviour; -- behaviour
