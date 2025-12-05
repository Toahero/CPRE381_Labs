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
        i_ExIns             : in t_Instruction;
        i_MemIns            : in t_Instruction;
        i_WbIns             : in t_Instruction;

        o_forwarding        : std_logic;
        o_ForwardSelRS1     : out std_logic_vector(1 downto 0);
        o_ForwardSelRS2     : out std_logic_vector(1 downto 0)
    );
end ForwardingUnit;

architecture dataflow of ForwardingUnit is
    
component ForwardCheckerMemToEx is
    port(
        i_MemInst     : in t_Instruction;
        i_ExInst       : in t_Instruction;

        o_forwardRS1    : out std_logic;
        o_forwardRS2    : out std_logic
    );

    --If RS1 needs forwarding
    signal s_forwardRS1     : std_logic;

    --If RS2 needs forwarding
    signal s_forwardRS2     : std_logic;

begin

end dataflow;
