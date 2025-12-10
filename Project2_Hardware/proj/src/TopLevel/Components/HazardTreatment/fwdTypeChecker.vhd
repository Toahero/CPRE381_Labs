library IEEE;
use IEEE.std_logic_1164.all;

entity fwdTypeChecker is
    port(
        
        i_ExOpCode        : in std_logic_vector(6 downto 0);
        i_FwdOpCode       : in std_logic_vector(6 downto 0);
        i_FromWb      : in std_logic;

        o_forwardRS1    : out std_logic;
        o_forwardRS2    : out std_logic
    );
end fwdTypeChecker;

architecture dataflow of fwdTypeChecker is
    
    signal s_canAddRS1  : std_logic;
    signal s_canAddRs2  : std_logic;
    signal s_ProducesRD : std_logic;

begin
    s_canAddRS1 <=
        '1' when (i_ExOpCode = "0110011") else --R type
        '1' when (i_ExOpCode = "0010011") else --I-ALU
        i_FromWb when (i_ExOpCode = "0000011") else --Can be forwarded from writeback, but not mem.
        '1' when (i_ExOpCode = "0100011") else --Store
        '1' when (i_ExOpCode = "1100011") else --Branch
        '1' when (i_ExOpCode = "1100111") else --JALR
        '1' when (i_ExOpCode = "1101111") else --JAL
        '0' when (i_ExOpCode = "0110111") else --lui
        '0' when (i_ExOpCode = "0010111") else --auipc
        '0' when (i_ExOpCode = "1110011") else --Enviroment
        '0';

    s_canAddRs2 <=
        '1' when (i_ExOpCode = "0110011") else --R type
        '0' when (i_ExOpCode = "0010011") else --I-ALU
        '0' when (i_ExOpCode = "0000011") else --Load
        '1' when (i_ExOpCode = "0100011") else --Store
        '1' when (i_ExOpCode = "1100011") else --Branch
        '0' when (i_ExOpCode = "1100111") else --JALR
        '0' when (i_ExOpCode = "1101111") else --JAL
        '0' when (i_ExOpCode = "0110111") else --lui
        '0' when (i_ExOpCode = "0010111") else --auipc
        '0' when (i_ExOpCode = "1110011") else --Enviroment
        '0';


    s_ProducesRD <=
        '1' when (i_FwdOpCode = "0110011") else --R type
        '1' when (i_FwdOpCode = "0010011") else --I-ALU
        '1' when (i_FwdOpCode = "0000011") else --Load
        '0' when (i_FwdOpCode = "0100011") else --Store
        '0' when (i_FwdOpCode = "1100011") else --Branch
        '1' when (i_FwdOpCode = "1100111") else --JALR
        '1' when (i_FwdOpCode = "1101111") else --JAL
        '1' when (i_FwdOpCode = "0110111") else --lui
        '0' when (i_FwdOpCode = "0010111") else --auipc
        '0' when (i_FwdOpCode = "1110011") else --Enviroment
        '0';

    o_forwardRS1 <= s_canAddRS1 and s_ProducesRD;
    o_forwardRS2 <= s_canAddRs2 and s_ProducesRD;
end dataflow;