library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);

        i_OutSel : in std_logic;
        i_ModSel : in std_logic;

        i_OppSel : in std_logic_vector(1 downto 0);

        o_Result : out std_logic_vector(31 downto 0);
        o_output : out std_logic_vector(31 downto 0);

        f_ovflw : out std_logic;
        f_zero : out std_logic;
        f_negative : out std_logic
    );
end ALU;

architecture behaviour of ALU is

    component addSub_n is
        generic(
            Comp_Width : integer -- Generic of type integer for input/output data width.
        );
        port(
            nAdd_Sub    : in std_logic;
            i_A		    : in std_logic_vector(Comp_Width-1 downto 0);
            i_B		    : in std_logic_vector(Comp_Width-1 downto 0);
            o_overflow	: out std_logic;
            o_Sum		: out std_logic_vector(Comp_Width-1 downto 0)
        );
    end component;

    component dualShift is
        generic(
            DATA_WIDTH  : positive;
            CNT_WIDTH   : positive
        );
        port(
            i_valueIn     : in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_shiftCount  : in std_logic_vector(CNT_WIDTH-1 downto 0); --The number of bits to be shifted
            i_arithmetic  : in std_logic;
            i_shiftLeft   : in std_logic; --0 for shift right, 1 for shift left
            o_valueOut    : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component IsNegative is
        generic(
            WIDTH           : integer := 32
        );
        port(
            i_Value         : in std_logic_vector(WIDTH - 1 downto 0);
            o_IsNegative    : out std_logic
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

    component mux2t1_N is
        generic(
            N : integer := 16 -- Generic of type integer for input/output data width. Default value is 32.
        );
        port(
            i_S          : in  std_logic;
            i_D0         : in  std_logic_vector((N - 1) downto 0);
            i_D1         : in  std_logic_vector((N - 1) downto 0);
            o_O          : out std_logic_vector((N - 1) downto 0)
        );
    end component;

    signal s_AddSubOutput : std_logic_vector(31 downto 0);
    signal s_BarrelShifterOutput : std_logic_vector(31 downto 0);

begin

    g_AddSub : addSub_n
        generic map(
            Comp_Width => 32
        )
        port map(
            nAdd_Sub    => i_OppSel(0),
            i_A		    => i_A,
            i_B		    => i_B,
            o_overflow	=> f_ovflw,
            o_Sum		=> s_AddSubOutput
        );
    
    g_BarrelShifter : dualShift
        generic map(
            DATA_WIDTH => 32,
            CNT_WIDTH => 5
        )
        port map(
            i_valueIn => i_A,
            i_shiftCount => i_B(4 downto 0),
            i_arithmetic => i_OppSel(0),
            i_shiftLeft => i_OppSel(1),

            o_valueOut => s_BarrelShifterOutput
        );

    g_OutputSelect : mux2t1_N
        generic map(
            N => 32
        )
        port map(
            i_S => i_ModSel,
            i_D0 => s_AddSubOutput,
            i_D1 => s_BarrelShifterOutput,
            o_O => o_output
        );

    g_IsNegative : IsNegative
        generic map(
            WIDTH => 32
        )
        port map(
            i_Value => s_AddSubOutput,
            o_IsNegative => f_negative
        );

    g_IsZero : IsZero
        generic map(
            WIDTH => 32
        )
        port map(
            i_Value => s_AddSubOutput,
            o_IsZero => f_zero
        );

end behaviour; -- arch
