library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Compare is
    port(
        i_A                 : in  std_logic_vector(31 downto 0);
        i_B                 : in  std_logic_vector(31 downto 0);
        i_slt_Unsigned      : in  std_logic;
        i_BranchCondition   : in  std_logic_vector(2 downto 0); -- Funct3
        
        o_Result_slt        : out std_logic_vector(31 downto 0);
        o_Result_Branch     : out std_logic
    );
end Compare;

architecture behvariour of Compare is

    signal s_eq     : std_logic;
    signal s_ne     : std_logic;
    signal s_lt     : std_logic;
    signal s_ge     : std_logic;
    signal s_ltu    : std_logic;
    signal s_geu    : std_logic;

    signal s_Padding : std_logic_vector(31 downto 1) := (others => '0');

begin

    s_eq            <=  '1'  when    i_A = i_B                          else '0';
    s_ne            <=  not s_eq;

    s_lt            <= '1'  when    to_integer(signed(i_A)) < to_integer(signed(i_B))     else '0';
    s_ge            <= not s_lt;

    s_ltu           <= '1'  when    to_integer(unsigned(i_A)) < to_integer(unsigned(i_B)) else '0';
    s_geu           <= not s_lt;

    o_Result_slt    <=  s_Padding & s_lt    when i_slt_Unsigned = '0'   else 
                        s_Padding & s_ltu   when i_slt_Unsigned = '1'   else
                        (others => 'X');

    o_Result_Branch <=  s_eq    when i_BranchCondition = "000"  else    -- BEQ
                        s_ne    when i_BranchCondition = "001"  else    -- BNE
                        s_lt    when i_BranchCondition = "100"  else    -- BLT
                        s_ge    when i_BranchCondition = "101"  else    -- BGE
                        s_ltu   when i_BranchCondition = "110"  else    -- BLTU
                        s_geu   when i_BranchCondition = "111"  else    -- BGEU
                        'X';

end behvariour;
