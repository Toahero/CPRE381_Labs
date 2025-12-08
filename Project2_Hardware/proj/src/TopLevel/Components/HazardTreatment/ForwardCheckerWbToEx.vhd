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
        i_WbInst       : in std_logic_vector(31 downto 0);

        o_forwardRS1    : out std_logic;
        o_forwardRS2    : out std_logic
    );
end ForwardCheckerMemToEx;

architecture dataflow of ForwardCheckerMemToEx is
    
    signal s_RS1_Fwdable_Type   : std_logic;
    signal s_RS2_Fwdable_Type   : std_logic;

    signal s_WbRD_EqualsExRS1  : std_logic;
    signal s_WbRD_EqualsExRS2  : std_logic;

    signal s_Wb_OppCode    : std_logic_vector(6 downto 0);
    signal s_Ex_OppCode     : std_logic_vector(6 downto 0);

    signal s_Wb_RD         : std_logic_vector(4 downto 0);

    signal s_Ex_RS1         : std_logic_vector(4 downto 0);
    signal s_Ex_RS2         : std_logic_vector(4 downto 0);

    signal canAddRS1  : std_logic;
    signal canAddRs2  : std_logic;

    signal s_ProducesRD : std_logic;


begin
    s_Ex_OppCode     <= i_ExInst(6 downto 0);
    s_Wb_OppCode     <= i_WbInst(6 downto 0);

    s_Wb_RD          <= i_WbInst(11 downto 7);
    s_Ex_RS1         <= i_ExInst(19 downto 15);
    s_Ex_RS2         <= i_ExInst(24 downto 20);

    canAddRS1 <=
        '1' when (s_EX_OppCode = "0110011") else --R type
        '1' when (s_EX_OppCode = "0010011") else --I-ALU
        '0' when (s_EX_OppCode = "0000011") else --Load --Can be accessed now that mem stage is complete
        '1' when (s_EX_OppCode = "0100011") else --Store
        '1' when (s_EX_OppCode = "1100011") else --Branch
        '1' when (s_EX_OppCode = "1100111") else --JALR
        '1' when (s_EX_OppCode = "1101111") else --JAL
        '0' when (s_EX_OppCode = "0110111") else --lui
        '0' when (s_EX_OppCode = "0010111") else --auipc
        '0' when (s_EX_OppCode = "1110011") else --Enviroment
        '0';

    canAddRs2 <=
        '1' when (s_EX_OppCode = "0110011") else --R type
        '0' when (s_EX_OppCode = "0010011") else --I-ALU
        '0' when (s_EX_OppCode = "0000011") else --Load
        '1' when (s_EX_OppCode = "0100011") else --Store
        '1' when (s_EX_OppCode = "1100011") else --Branch
        '0' when (s_EX_OppCode = "1100111") else --JALR
        '0' when (s_EX_OppCode = "1101111") else --JAL
        '0' when (s_EX_OppCode = "0110111") else --lui
        '0' when (s_EX_OppCode = "0010111") else --auipc
        '0' when (s_EX_OppCode = "1110011") else --Enviroment
        '0';


    s_ProducesRD <=
        '1' when (s_Wb_OppCode = "0110011") else --R type
        '1' when (s_Wb_OppCode = "0010011") else --I-ALU
        '1' when (s_Wb_OppCode = "0000011") else --Load
        '0' when (s_Wb_OppCode = "0100011") else --Store
        '0' when (s_Wb_OppCode = "1100011") else --Branch
        '1' when (s_Wb_OppCode = "1100111") else --JALR
        '1' when (s_Wb_OppCode = "1101111") else --JAL
        '1' when (s_Wb_OppCode = "0110111") else --lui
        '0' when (s_Wb_OppCode = "0010111") else --auipc
        '0' when (s_Wb_OppCode = "1110011") else --Enviroment
        '0';

        s_RS1_Fwdable_Type <= canAddRS1 and s_ProducesRD;
        s_RS2_Fwdable_Type <= canAddRs2 and s_ProducesRD;

    s_WbRD_EqualsExRS1 <=
        '1' when (s_Wb_RD = s_Ex_RS1) else
        '0';

    s_WbRD_EqualsExRS2 <=
        '1' when (s_Wb_RD = s_Ex_RS2) else
        '0';

    o_forwardRS1 <= s_RS1_Fwdable_Type AND s_WbRD_EqualsExRS1;

    o_forwardRS2 <= s_RS2_Fwdable_Type AND s_WbRD_EqualsExRS2;
end dataflow;