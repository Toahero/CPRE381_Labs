-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: none
--Takes two instructions, and checks if the first must forward to the second
--ForwardCheckerWbToEx.vhd
-------------------------------------------------------------------------
--12/5/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardCheckerWbToEx is
    port(
        i_ExInst        : in std_logic_vector(31 downto 0);
        i_WbInst       : in std_logic_vector(31 downto 0);

        o_forwardRS1    : out std_logic;
        o_forwardRS2    : out std_logic
    );
end ForwardCheckerWbToEx;

architecture dataflow of ForwardCheckerWbToEx is
    
    signal s_RS1_Fwdable_Type   : std_logic;
    signal s_RS2_Fwdable_Type   : std_logic;

    signal s_WbRD_EqualsExRS1  : std_logic;
    signal s_WbRD_EqualsExRS2  : std_logic;

    signal s_Wb_OppCode    : std_logic_vector(6 downto 0);
    signal s_Ex_OppCode     : std_logic_vector(6 downto 0);

    signal s_Wb_RD         : std_logic_vector(4 downto 0);

    signal s_Ex_RS1         : std_logic_vector(4 downto 0);
    signal s_Ex_RS2         : std_logic_vector(4 downto 0);

begin
    s_Wb_OppCode <= i_WbInst(6 downto 0);
    s_Ex_OppCode  <= i_ExInst(6 downto 0);

    s_Wb_RD         <= i_WbInst(11 downto 7);

    s_Ex_RS1         <= i_WbInst(19 downto 15);
    s_Ex_RS2         <= i_WbInst(24 downto 20);

    s_RS1_Fwdable_Type <=
        '0' when (s_Ex_OppCode = "0100011") else --U types cannot be a consumer
        '0' when (s_Ex_OppCode = "1101111") else --J types cannot be a consumer

        '0' when (s_Wb_OppCode = "0100011") else --S types cannot be a producer
        '0' when (s_Wb_OppCode = "1100011") else --B types cannot be a producer
        '1' when (s_Wb_OppCode = "0000011") else --In the writeback stage, load I types can forward
        '1';

    s_RS2_Fwdable_Type <=
        '0' when (s_Ex_OppCode = "0100011") else --U types cannot be a consumer
        '0' when (s_Ex_OppCode = "1101111") else --J types cannot be a consumer
        '0' when (s_Ex_OppCode = "0010011") else --I types have no RS1
        '0' when (s_Ex_OppCode = "1100111") else --Ditto
        '0' when (s_Ex_OppCode = "1110011") else --Ditto

        '0' when (s_Wb_OppCode = "0100011") else --S types cannot be a producer
        '0' when (s_Wb_OppCode = "1100011") else --B types cannot be a producer
        '0' when (s_Wb_OppCode = "0000011") else --In the writeback stage, load I types can forward
        '1';

    s_WbRD_EqualsExRS1 <=
        '1' when (s_Wb_RD = s_Ex_RS1) else
        '0';

    s_WbRD_EqualsExRS2 <=
        '1' when (s_Wb_RD = s_Ex_RS2) else
        '0';

    o_forwardRS1 <= s_RS1_Fwdable_Type AND s_WbRD_EqualsExRS1;

    o_forwardRS2 <= s_RS2_Fwdable_Type AND s_WbRD_EqualsExRS2;
end dataflow;