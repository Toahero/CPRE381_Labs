-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: none
--Takes two instructions, and checks if the first must forward to the second
--ForwardCheckerMemToEx.vhd
-------------------------------------------------------------------------
--12/5/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardCheckerMemToEx is
    port(
        i_ExInst        : in std_logic_vector(31 downto 0);
        i_MemInst       : in std_logic_vector(31 downto 0);

        o_forwardRS1    : out std_logic;
        o_forwardRS2    : out std_logic
    );
end ForwardCheckerMemToEx;

architecture dataflow of ForwardCheckerMemToEx is
    
    signal s_RS1_Fwdable_Type   : std_logic;
    signal s_RS2_Fwdable_Type   : std_logic;

    signal s_MemRD_EqualsExRS1  : std_logic;
    signal s_MemRD_EqualsExRS2  : std_logic;

    signal s_Mem_OppCode    : std_logic_vector(6 downto 0);
    signal s_Ex_OppCode     : std_logic_vector(6 downto 0);

    signal s_Mem_RD         : std_logic_vector(4 downto 0);

    signal s_Ex_RS1         : std_logic_vector(4 downto 0);
    signal s_Ex_RS2         : std_logic_vector(4 downto 0);

begin
    s_Mem_OppCode <= i_MemInst(6 downto 0);
    s_Ex_OppCode  <= i_ExInst(6 downto 0);

    s_Mem_RD         <= i_MemInst(11 downto 7);

    s_Ex_RS1         <= i_MemInst(19 downto 15);
    s_Ex_RS2         <= i_MemInst(24 downto 20);

    s_RS1_Fwdable_Type <=
        '0' when (s_Ex_OppCode = "0100011") else --U types cannot be a consumer
        '0' when (s_Ex_OppCode = "1101111") else --J types cannot be a consumer

        '0' when (s_Mem_OppCode = "0100011") else --S types cannot be a producer
        '0' when (s_Mem_OppCode = "1100011") else --B types cannot be a producer
        '0' when (s_Mem_OppCode = "0000011") else --Load I types cannot forward until the writeback stage
        '1';

    s_RS2_Fwdable_Type <=
        '0' when (s_Ex_OppCode = "0100011") else --U types cannot be a consumer
        '0' when (s_Ex_OppCode = "1101111") else --J types cannot be a consumer
        '0' when (s_Ex_OppCode = "0010011") else --I types have no RS1
        '0' when (s_Ex_OppCode = "1100111") else --Ditto
        '0' when (s_Ex_OppCode = "1110011") else --Ditto

        '0' when (s_Mem_OppCode = "0100011") else --S types cannot be a producer
        '0' when (s_Mem_OppCode = "1100011") else --B types cannot be a producer
        '0' when (s_Mem_OppCode = "0000011") else --Load I types cannot forward until the writeback stage
        '1';

    s_MemRD_EqualsExRS1 <=
        '0' when (s_Mem_RD = "00000") else --NoP
        '1' when (s_Mem_RD = s_Ex_RS1) else
        '0';

    s_MemRD_EqualsExRS2 <=
        '0' when (s_Mem_RD = "00000") else --Nop
        '1' when (s_Mem_RD = s_Ex_RS2) else
        '0';

    o_forwardRS1 <= s_RS1_Fwdable_Type AND s_MemRD_EqualsExRS1;

    o_forwardRS2 <= s_RS2_Fwdable_Type AND s_MemRD_EqualsExRS2;
end dataflow;