library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        i_A         : in std_logic_vector(31 downto 0);
        i_B         : in std_logic_vector(31 downto 0);
        i_Sub       : in std_logic;

        o_Result    : out std_logic_vector(31 downto 0);
        f_Zero      : out std_logic;
        f_Overflow  : out std_logic;
        f_Negative  : out std_logic
    );
end ALU;

architecture behaviour of ALU is

    component addSub_n is
        generic(
            Comp_Width : integer
        );
        port(
            nAdd_Sub	: in std_logic;
            i_A		    : in std_logic_vector(Comp_Width-1 downto 0);
            i_B		    : in std_logic_vector(Comp_Width-1 downto 0);
            o_overflow	: out std_logic;
            o_Sum		: out std_logic_vector(Comp_Width-1 downto 0)
        );
    end component;

    component IsZero is
        generic(
            WIDTH : integer := 32
        );
        port(
            i_Value : in std_logic_vector(WIDTH - 1 downto 0);
            o_IsZero : out std_logic := '0'
        );
    end component;

    component IsNegative is
        generic(
            WIDTH           : integer := 32
        );
        port(
            i_Value         : in std_logic_vector(WIDTH downto 0);
            o_IsNegative    : out std_logic
        );
    end component;

    signal s_AddSubResult : std_logic_vector(31 downto 0);

begin

    o_Result <= s_AddSubResult;

    g_AddSub : addSub_n
        generic map(
            Comp_Width      => 32
        )
        port map(
            nAdd_Sub        => i_Sub,
            i_A             => i_A,
            i_B             => i_B,

            o_overflow      => f_Overflow,
            o_Sum           => s_AddSubResult
        );

    g_IsZero : IsZero
        generic map(
            WIDTH           => 32
        )
        port map(
            i_Value         => s_AddSubResult,
            o_IsZero        => f_Zero
        );

    g_IsNegative : IsNegative
        generic map(
            WIDTH           => 32
        )
        port map(
            i_Value         => s_AddSubResult,
            o_IsNegative    => f_Negative
        );

end behaviour; -- arch
