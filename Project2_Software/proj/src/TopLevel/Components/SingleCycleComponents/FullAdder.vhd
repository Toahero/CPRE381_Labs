library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
    port(
        i_A : in std_logic;
        i_B : in std_logic;
        i_C : in std_logic;

        o_S : out std_logic;
        o_C : out std_logic
    );
end FullAdder;

architecture behaviour of FullAdder is 

    component org2 is 
        port(
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;

    component andg2 is 
        port(
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;

    component xorg2 is
        port(
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;

    signal s_AoB : std_logic;
    signal s_AaB : std_logic;
    signal s_AxB : std_logic;
    signal s_O21 : std_logic;

begin

    g_AoB : org2
        port map(
            i_A => i_A,
            i_B => i_B,
            o_F => s_AoB
        );
    
    g_AaB : andg2
        port map(
            i_A => i_A,
            i_B => i_B,
            o_F => s_AaB
        );

    g_AxB : xorg2
        port map(
            i_A => i_A,
            i_B => i_B,
            o_F => s_AxB
        );
    
    g_O21 : andg2
        port map(
            i_A => s_AoB,
            i_B => i_C,
            o_F => s_O21
        );

    g_O2F : org2
        port map(
            i_A => s_O21,
            i_B => s_AaB,
            o_F => o_C
        );

    g_O1F : xorg2
        port map(
            i_A => s_AxB,
            i_B => i_C,
            o_F => o_S
        );

end architecture;
