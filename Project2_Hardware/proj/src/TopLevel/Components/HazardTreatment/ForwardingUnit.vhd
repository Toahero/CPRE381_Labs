-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: none
--Forwarding Unit
--ForwardingUnit.vhd
-------------------------------------------------------------------------
--11/14/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.t_InstructionType;

entity ForwardingUnit is
    port(
        i_ExInst             : in std_logic_vector(31 downto 0);
        i_MemInst            : in std_logic_vector(31 downto 0);
        i_WbInst             : in std_logic_vector(31 downto 0);

        o_ForwardSelRS1     : out std_logic_vector(1 downto 0);
        o_ForwardSelRS2     : out std_logic_vector(1 downto 0)
    );
end ForwardingUnit;

architecture dataflow of ForwardingUnit is
    
    component ForwardCheckerMemToEx is
        port(
            i_ExInst       : in std_logic_vector(31 downto 0);
            i_MemInst     : in std_logic_vector(31 downto 0);

            o_forwardRS1    : out std_logic;
            o_forwardRS2    : out std_logic
        );
    end component;

    component ForwardCheckerWbToEx is
        port(
            i_ExInst       : in std_logic_vector(31 downto 0);
            i_WbInst     : in std_logic_vector(31 downto 0);

            o_forwardRS1    : out std_logic;
            o_forwardRS2    : out std_logic
        );
    end component;

    --If WbRd would affect ExRS1
    signal s_WbRd_ExRS1     : std_logic;

    --If WbRd would affect ExRS2
    signal s_WbRd_ExRS2     : std_logic;


    --If MemRD would affect ExRS1
    signal s_MemRD_ExRS1     : std_logic;

    --If MemRD would affect ExRS2
    signal s_MemRD_ExRS2    : std_logic;

begin
    g_WbChecker :   ForwardCheckerWbToEx
        port map(
            i_ExInst    => i_ExInst,
            i_WbInst    => i_WbInst,

            o_forwardRS1    => s_WbRD_ExRS1,
            o_forwardRS2    => s_WbRD_EXRS2
        );

    g_MemChecker    : ForwardCheckerMemToEx
        port map(
            i_ExInst    => i_ExInst,
            i_MemInst   => i_MemInst,
            
            o_forwardRS1    => s_MemRD_ExRS1,
            o_forwardRS2    => s_MemRD_ExRS2
        );

    o_ForwardSelRS1 <=
            "01" when (s_MemRD_ExRS1 = '1')   else --If Mem is forwardable, forward from that register.
            "10" when (s_WbRD_ExRS1   = '1')   else --Otherwise, if WB is forwardable, forward from that register
            "00"; --Otherwise, no forwarding

    o_ForwardSelRS2 <=
            "01" when (s_MemRD_ExRS2 = '1')   else --If Mem is forwardable, forward from that register.
            "10" when (s_WbRD_EXRS2   = '1')   else --Otherwise, if WB is forwardable, forward from that register
            "00"; --Otherwise, no forwarding

end dataflow;
