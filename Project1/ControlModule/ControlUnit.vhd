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
use IEEE.numeric_std.all;

entity ControlUnit is
    generic (ALU_OP_SIZE : positive := 4);
    port(
        opCode      : in std_logic_vector(6 downto 0); --The Opcode is 7 bits long

        --These have been assigned
        ALU_Src      : out std_logic; --Source an extended immediate
        Mem_We      : out std_logic; --Enable writing to memory
        Jump        : out std_logic; --Execute a jump
        MemToReg    : out std_logic; --Write a memory value into a register
        Reg_WE      : out std_logic;
        Branch      : out std_logic;
        
        --These have not been assigned   
        ALU_OP      : out std_logic_vector(ALU_OP_SIZE-1 downto 0));

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
                    '0' when "1100011", --B type Instruction
                    '1' when others;

    with opCode select
        Branch  <=  '0' when "1100011", --B type instruction
                    '1' when others;

    with opCode select
        ALU_OP  <=  std_logic_vector(to_unsigned(0, ALU_OP_SIZE)) when "0110011", --Register Arithmetic (R-Type)
                    std_logic_vector(to_unsigned(1, ALU_OP_SIZE))  when "0010011", --Immediate Arithmetic (I-Type)
                    std_logic_vector(to_unsigned(2, ALU_OP_SIZE))  when "0000011", --Load (I-type)
                    std_logic_vector(to_unsigned(3, ALU_OP_SIZE))  when "0100011", --Store (S type)
                    std_logic_vector(to_unsigned(4, ALU_OP_SIZE)) when "1100011", --Branch (B-type)
                    std_logic_vector(to_unsigned(5, ALU_OP_SIZE)) when "1101111", --Jump and Link (J-type)
                    std_logic_vector(to_unsigned(6, ALU_OP_SIZE)) when "1100111", --Jump and Link Reg (I-type)
                    std_logic_vector(to_unsigned(7, ALU_OP_SIZE)) when "0110111", --Load Upper Imm (U Type)
                    std_logic_vector(to_unsigned(8, ALU_OP_SIZE)) when others; --Use for halting?

end dataflow;
            