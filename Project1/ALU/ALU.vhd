library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);

        i_OutSel : in std_logic;
        i_ModSel : in std_logic_vector(1 downto 0);

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
            Comp_Width : integer
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
            i_shiftLeft   : in std_logic;
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
            N : integer := 16
        );
        port(
            i_S          : in  std_logic;
            i_D0         : in  std_logic_vector((N - 1) downto 0);
            i_D1         : in  std_logic_vector((N - 1) downto 0);
            o_O          : out std_logic_vector((N - 1) downto 0)
        );
    end component;
    
    component Mux4t1 is
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
    end component;

    component BitMux4t1 is
        port(
            i_Selection : in std_logic_vector(1 downto 0);
    
            i_D0 : in std_logic;
            i_D1 : in std_logic;
            i_D2 : in std_logic;
            i_D3 : in std_logic;
    
            o_Output : out std_logic
        );
    end component;

    signal s_AddSubOutput : std_logic_vector(31 downto 0);
    signal s_BarrelShifterOutput : std_logic_vector(31 downto 0);

    signal s_Flag_AddSub_Overflow : std_logic;

    signal s_Flag_Overflow : std_logic;

begin

    f_ovflw <= s_Flag_Overflow;

    g_AddSub : addSub_n
        generic map(
            Comp_Width => 32
        )
        port map(
            nAdd_Sub    => i_OppSel(0),
            i_A		    => i_A,
            i_B		    => i_B,
            o_overflow	=> s_Flag_AddSub_Overflow,
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

    g_ModuleSelect : Mux4t1
        generic map(
            DATA_WIDTH => 32
        )
        port map(
            i_Selection  => i_ModSel,
            i_D0 => s_AddSubOutput,
            i_D1 => (others => '0'),
            i_D2 => s_BarrelShifterOutput,
            i_D3 => (others => '0'),
            o_Output  => o_output
        );

    g_Flag_Select_Overflow : BitMux4t1
        port map(
            i_Selection => i_ModSel,
            i_D0        =>  s_Flag_AddSub_Overflow,
            i_D1        =>  '0',
            i_D2        =>  '0',
            i_D3        =>  '0',
            o_Output    =>  s_Flag_Overflow
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

end behaviour;
