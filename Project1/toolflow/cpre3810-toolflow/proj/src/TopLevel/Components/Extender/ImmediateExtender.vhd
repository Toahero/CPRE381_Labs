-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: None
--Description: an extender module for RISCV immediates

-- ImmediateExtender.vhd
-------------------------------------------------------------------------
--10/24/25 by JAG: Initially Created
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity ImmediateExtender is
    port(
    i_instruction   : in std_logic_vector(31 downto 0);
    o_output        : out std_logic_vector(31 downto 0));
end ImmediateExtender;

architecture dataflow of ImmediateExtender is
    signal s_oppCode     : std_logic_vector(6 downto 0);
    signal s_funct3     : std_logic_vector(2 downto 0);
    
    signal extBit       : std_logic;

    signal s_iTypeIn     : std_logic_vector(11 downto 0);
    signal s_iTypeExt    : std_logic_vector(31 downto 12);

    signal s_sTypeIn    : std_logic_vector(11 downto 0);
    signal s_sTypeExt   : std_logic_vector(31 downto 12);

    signal s_bTypeIn    : std_logic_vector(12 downto 0);
    signal s_bTypeExt   : std_logic_vector(31 downto 13);

    signal s_uTypeIn     : std_logic_vector(19 downto 0);
    signal s_uTypeExt   : std_logic_vector(31 downto 20);

    signal s_jTypeIn     : std_logic_vector(20 downto 0);
    signal s_jTypeExt   :   std_logic_vector(31 downto 21);

    signal s_iTypeOut  : std_logic_vector(31 downto 0);
    signal s_sTypeOut  : std_logic_vector(31 downto 0);
    signal s_bTypeOut  : std_logic_vector(31 downto 0);
    signal s_uTypeOut  : std_logic_vector(31 downto 0);
    signal s_jTypeOut  : std_logic_vector(31 downto 0);

begin

    --Set each value to the relevant bits of the instruction
    s_oppCode   <= i_instruction(6 downto 0);
    s_funct3    <= i_instruction(14 downto 12);
    --s_funct7    <= i_instruction(31 downto 25);

    --Set the input (non extended) vectors

    s_iTypeIn      <= i_instruction(31 downto 20);

    s_sTypeIn      <= i_instruction(31 downto 25) & i_instruction(11 downto 7);

    s_bTypeIn   <= i_instruction(31) & i_instruction(7) & i_instruction(30 downto 25) & i_instruction(11 downto 8) & "0";
    
    s_uTypeIn     <= i_instruction(31 downto 12);

    --s_jTypeIn     <= i_instruction(31) & i_instruction(18 downto 12) & i_instruction(19) & i_instruction(30 downto 20) & "0";
    s_jTypeIn     <= i_instruction(31) & i_instruction(19 downto 12) & i_instruction(30 downto 20) & "0";

    --Set the extension bit
    extBit <=   --standard I type instructions
        '1' when ((s_oppCode = "0010011") and ((s_funct3 = "000") or (s_funct3 = "011")) and (i_instruction(31) = '1')) else --For ADDI and SLTIU, sign extend.
        '0' when s_oppCode = "0010011" else --Other standard I type instructions

        --Load I type instructions
        '0' when (s_oppCode = "0000011" and ((s_funct3 = "100") or (s_funct3 = "101"))) else --Unsigned Load instructions
        '1' when ((s_oppCode = "0000011") and (i_instruction(31) = '1')) else --Signed load part 1
        '0' when s_oppCode = "0000011" else --Signed Load part 2

        --Jump and Link Register instruction
        '1' when (s_oppCode = "1100111" and (i_instruction(31) = '1')) else
        '0' when s_oppCode = "1100111" else
        
        --S type instructions
        '0' when s_oppCode = "0100011" else --Store commands are always unsigned
        
        --B type instructions
        '1' when (s_oppCode = "1100011" and (i_instruction(31) = '1')) else --B type immediates are always sign extended
        '0' when s_oppCode = "1100011" else

        --U type Instructions
        '0' when s_oppCode = "0110111" else --U type immediates are always extended with zeroes at the back

        --J type instructions
        '1' when (s_oppCode = "1101111" and (i_instruction(31) = '1')) else --j (jump) type immediates are always signed
        '0' when s_oppCode = "1101111" else 
        '0';


        --Set each extension bit
     s_iTypeExt <= (others => extBit);
     s_sTypeExt <= (others => extBit);
     s_bTypeExt <= (others => extBit);
     s_uTypeExt <= (others => extBit);
     s_jTypeExt <= (others => extBit);
    
    --Combine input and extension vectors to make the output vectors
    s_iTypeOut <= s_iTypeExt & s_iTypeIn;
    s_sTypeOut <= s_sTypeExt & s_sTypeIn;
    s_bTypeOut <= s_bTypeExt & s_bTypeIn;
    s_uTypeOut <= s_uTypeIn & s_uTypeExt; --U type are zero extended on the back
    s_jTypeOut <= s_jTypeExt & s_jTypeIn;


    --Based on the oppcode, output the relavent extended vector
with s_oppCode select 
    o_output <=
        s_iTypeOut when "0010011" | "0000011" | "1100111"| "1110011",
        s_sTypeOut when "0100011",
        s_bTypeOut when "1100011",
        s_uTypeOut when "0110111"| "0010111",
        s_jTypeOut when "1101111",
        s_iTypeOut when others;

end dataflow;