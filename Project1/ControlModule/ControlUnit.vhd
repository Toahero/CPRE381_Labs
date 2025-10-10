-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: None
--Description: Control Module for a simple RISC-V Processor

-- ControlUnit.vhd
-------------------------------------------------------------------------
--10/8/25 by JAG: Initially Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity ControlUnit is
    port(
        opCode      : in std_logic_vector(6 downto 0); --The Opcode is 7 bits long
        funt7_imm   : in std_logic_vector(6 downto 0); --Funct7 is 3 bits long

        --These have been assigned
        ALU_Src      : out std_logic; --Source an extended immediate
        Mem_We      : out std_logic; --Enable writing to memory
        Jump        : out std_logic; --Execute a jump
        MemToReg    : out std_logic; --Write a memory value into a register
        Reg_WE      : out std_logic;
        Branch      : out std_logic;
        
        --These have not been assigned   
        ALU_OP      : out std_logic_vector(2 downto 0));

    end ControlUnit;

architecture dataflow of ControlUnit is
    
begin
    with opCode select
        ALU_Src <=  '0' when "0110011", --R format does not use an immediate
                    '1' when others;    --All other instruction formats use an immediate
                
    with opCode select
        Mem_We  <=  '1' when "0100011", --S format loads a value into memory
                    '0' when others;

    with opCode select
        jump    <= '1' when "1101111", --jal (jump and link)
		'1' when "1100111", --jalR (jump and link reg)
		'0' when others;

    with opCode select
        MemToReg    <=  '1' when "0000011", --Load Instructions
                        '0' when others;
    
    with opCode select
        Reg_WE  <=  '0' when "0100011", --S type instruction
                    '1' when others;

    with opCode select
        Branch  <=  '1' when "1100011", --B type instruction
                    '0' when others;

    ALU_OP  <=
            "001" when (opCode = "0110011") else --R type Instruction
            "010" when (opCode = "0010011" OR opCode = "0000011" OR opCode = "1100111"
                OR opCode = "1110011" OR opCode = "1110011") else --I type Instruction
            "011" when (opCode = "0100011") else --S type Instruction
            "100" when (opCode = "1100011") else --B Type Instruction
            "101" when (opCode = "0110111" OR opCode = "0010111") else --U Type Instruction
            "110" when (opCode = "1101111") else --UJ Type Instruction
            "000"; --Invalid opCode (Maybe also use for halt?)
end dataflow;
