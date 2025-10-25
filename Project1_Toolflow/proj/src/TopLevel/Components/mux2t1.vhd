library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is 
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
end mux2t1;

architecture structural of mux2t1 is

    -- signal s_nS         : std_logic;
    -- signal s_s0         : std_logic;
    -- signal s_s1         : std_logic;

begin

    o_O <=  i_D0 when (i_S = '0') else
            i_D1 when (i_S = '1') else
            '0';

    -- -- Stage 1 : Inverting S
    -- g_nS: invg
    --     port MAP(
    --         i_A         => i_Selection,
    --         o_F         => s_nS
    --     );

    -- -- Stage 2 : Selecting the correct path
    -- g_s0: andg2
    --     port MAP(
    --         i_A         => s_nS,
    --         i_B         => i_A,
    --         o_F         => s_s0
    --     );

    -- g_s1: andg2
    --     port MAP(
    --         i_A         => i_Selection,
    --         i_B         => i_B,
    --         o_F         => s_s1
    --     );

    -- -- Stage 3 : Merging the selections
    -- g_merge: org2
    --     port MAP(
    --         i_A         => s_s0,
    --         i_B         => s_s1,
    --         o_F         => o_Q
    --     );

end structural;