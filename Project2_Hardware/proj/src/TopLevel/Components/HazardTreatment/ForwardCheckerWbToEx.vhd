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

entity ForwardChecker is
    port(
        i_MemInst       : in std_logic_vector(31 downto 0);
        i_ExInst        : in std_logic_vector(31 downto 0);

        o_forwardRS1    : out std_logic;
        o_forwardRS2    : out std_logic
    );
end ForwardChecker;

architecture dataflow of ForwardChecker is
    
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
    s_RS1_Fwdable_Type <=
        '1' when (s_Mem_OppCode = "0110011") AND (s_Mem_OppCode = "0110011") else --R Type to R type
        '1' when (s_Mem_OppCode = "0110011") AND (s_Mem_OppCode = "0010011") else --R Type to I type(op)
        '1' when (s_Mem_OppCode = "0010011") AND (s_Mem_OppCode = "0110011") else --I type(op)to R type
        '1' when (s_Mem_OppCode = "0010011") AND (s_Mem_OppCode = "0010011") else --I type(op) to I type(op)
        '0';

    s_RS2_Fwdable_Type <=
        '1' when (s_Mem_OppCode = "0110011") AND (s_Mem_OppCode = "0110011") else --R Type to R type
        '0' when (s_Mem_OppCode = "0110011") AND (s_Mem_OppCode = "0010011") else --R Type to I type(op) --I types have no RS2
        '0' when (s_Mem_OppCode = "0010011") AND (s_Mem_OppCode = "0110011") else --I type(op)to R type  
        '0' when (s_Mem_OppCode = "0010011") AND (s_Mem_OppCode = "0010011") else --I type(op) to I type(op)
        '0';

    s_MemRD_EqualsExRS1 <=
        '1' when (s_Mem_RD = s_Ex_RS1) else
        '0';

    s_MemRD_EqualsExRS2 <=
        '1' when (s_Mem_RD = s_Ex_RS2) else
        '0';

    o_forwardRS1 <= s_RS1_Fwdable_Type AND s_MemRD_EqualsExRS1;

    o_forwardRS2 <= s_RS2_Fwdable_Type AND s_MemRD_EqualsExRS2;
end dataflow;