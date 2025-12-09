library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC_Increment is
    generic(
        ADDR_WIDTH : integer := 32
    );
    port(
        i_Pause     : in std_logic;
        i_CurrAddr  : in std_logic_vector(ADDR_WIDTH -1 downto 0);
        
        o_NextAddr  : out std_logic_vector(ADDR_WIDTH -1 downto 0)
    );
end PC_Increment;

architecture mixed of PC_Increment is
    component AddSub is
        generic(
            WIDTH : integer
        );
        port(
            i_A : in std_logic_vector(WIDTH - 1 downto 0);
            i_B : in std_logic_vector(WIDTH - 1 downto 0);
            n_Add_Sub : in std_logic;

            o_S : out std_logic_vector(WIDTH - 1 downto 0);
            o_C : out std_logic
        );
    end component;

    signal s_plusFour   : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal s_ovflw      : std_logic;

begin
    g_Incr_Adder : AddSub
        generic map( Width => ADDR_WIDTH)
        port map(
            i_A         => i_CurrAddr,
            i_B         => std_logic_vector(to_unsigned(4, ADDR_WIDTH)),
            n_Add_Sub   => '0',
            o_S         => s_plusFour,
            o_C         => s_ovflw
        );

    o_NextAddr <=
            i_CurrAddr when (i_Pause = '1') else
            s_plusFour;

end mixed;