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
    
    signal s_canConsumeRS1  : std_logic;
    signal s_canConsumeRs2  : std_logic;
    signal s_ProducesRD : std_logic;

begin
    s_canConsumeRS1 <=
        '1' when (i_ExOpCode = "0110011") else --R type
        '1' when (i_ExOpCode = "0010011") else --I-ALU
        '1' when (i_ExOpCode = "0000011") else --Load Type
        '1' when (i_ExOpCode = "0100011") else --Store --This is supposed to be an edge case
        '1' when (i_ExOpCode = "1100011") else --Branch
        '1' when (i_ExOpCode = "1100111") else --JALR
        '1' when (i_ExOpCode = "1101111") else --JAL
        '0' when (i_ExOpCode = "0110111") else --lui
        '0' when (i_ExOpCode = "0010111") else --auipc
        '0' when (i_ExOpCode = "1110011") else --Enviroment
        '0';

    s_canConsumeRs2 <=
        '1' when (i_ExOpCode = "0110011") else --R type
        '0' when (i_ExOpCode = "0010011") else --I-ALU
        '0' when (i_ExOpCode = "0000011") else --Load
        '1' when (i_ExOpCode = "0100011") else --Store --This is supposed to be an edge case
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
        i_FromWb  when (i_FwdOpCode = "0000011") else --Load (Can be forwarded from writeback, but not mem)
        '0' when (i_FwdOpCode = "0100011") else --Store
        '0' when (i_FwdOpCode = "1100011") else --Branch
        '1' when (i_FwdOpCode = "1100111") else --JALR
        '1' when (i_FwdOpCode = "1101111") else --JAL
        '1' when (i_FwdOpCode = "0110111") else --lui
        '0' when (i_FwdOpCode = "0010111") else --auipc
        '0' when (i_FwdOpCode = "1110011") else --Enviroment
        '0';

    o_forwardRS1 <= s_canConsumeRS1 and s_ProducesRD;
    o_forwardRS2 <= s_canConsumeRs2 and s_ProducesRD;
end dataflow;