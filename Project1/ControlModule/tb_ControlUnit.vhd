library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.InstructionPackage.all;

entity tb_ControlUnit is
    generic(
        clock : time := 10 ns
    );
end tb_ControlUnit;

architecture behaviour of tb_ControlUnit is

    component ControlUnit is
        port(
            opCode      : in std_logic_vector(6 downto 0); --The Opcode is 7 bits long
            funt7_imm   : in std_logic_vector(6 downto 0); --Funct7 is 3 bits long
    
            --These have been assigned
            ALU_Src     : out std_logic; --Source an extended immediate
            Mem_We      : out std_logic; --Enable writing to memory
            Jump        : out std_logic; --Execute a jump
            MemToReg    : out std_logic; --Write a memory value into a register
            Reg_WE      : out std_logic;
            Branch      : out std_logic;
            
            ALU_OP      : out std_logic_vector(2 downto 0)
        );
    end component;

    signal s_i_opCode      : std_logic_vector(6 downto 0);
    signal s_i_funt7_imm   : std_logic_vector(6 downto 0) := "0000000";
    signal s_ALU_Src       : std_logic;
    signal s_Mem_We        : std_logic;
    signal s_Jump          : std_logic;
    signal s_MemToReg      : std_logic;
    signal s_Reg_WE        : std_logic;
    signal s_Branch        : std_logic;
    signal s_ALU_OP        : std_logic_vector(2 downto 0);

begin

    testbench : ControlUnit
        port map(
            opCode      => s_i_opCode,
            funt7_imm   => s_i_funt7_imm,
            ALU_Src     => s_ALU_Src,
            Mem_We      => s_Mem_We,
            Jump        => s_Jump,
            MemToReg    => s_MemToReg,
            Reg_WE      => s_Reg_WE,
            Branch      => s_Branch,
            ALU_OP      => s_ALU_OP
        );

    tests : process
    begin
        wait for (clock / 4);

        -- Base State
        s_i_opCode      <= "0000000";
        wait for clock;

        -- Test Case 1
        s_i_opCode          <= OPCODE_ADD;
        wait for clock;
        assert s_ALU_Src    = '0' report "Test Case 1 Failed" severity FAILURE;
        assert s_Mem_We     = '0' report "Test Case 1 Failed" severity FAILURE;
        assert s_Jump       = '0' report "Test Case 1 Failed" severity FAILURE;
        assert s_MemToReg   = '0' report "Test Case 1 Failed" severity FAILURE;
        assert s_Reg_WE     = '1' report "Test Case 1 Failed" severity FAILURE;
        assert s_Branch     = '0' report "Test Case 1 Failed" severity FAILURE;

        -- Test Case 2
        s_i_opCode          <= OPCODE_ADDI;
        wait for clock;
        assert s_ALU_Src    = '1' report "Test Case 2 Failed" severity FAILURE;
        assert s_Mem_We     = '0' report "Test Case 2 Failed" severity FAILURE;
        assert s_Jump       = '0' report "Test Case 2 Failed" severity FAILURE;
        assert s_MemToReg   = '0' report "Test Case 2 Failed" severity FAILURE;
        assert s_Reg_WE     = '1' report "Test Case 2 Failed" severity FAILURE;
        assert s_Branch     = '0' report "Test Case 2 Failed" severity FAILURE;

        -- Test Case 3
        s_i_opCode          <= OPCODE_LB;
        wait for clock;
        assert s_ALU_Src    = '1' report "Test Case 3 Failed" severity FAILURE;
        assert s_Mem_We     = '0' report "Test Case 3 Failed" severity FAILURE;
        assert s_Jump       = '0' report "Test Case 3 Failed" severity FAILURE;
        assert s_MemToReg   = '1' report "Test Case 3 Failed" severity FAILURE;
        assert s_Reg_WE     = '1' report "Test Case 3 Failed" severity FAILURE;
        assert s_Branch     = '0' report "Test Case 3 Failed" severity FAILURE;

        -- Test Case 4
        s_i_opCode          <= OPCODE_SB;
        wait for clock;
        assert s_ALU_Src    = '1' report "Test Case 4 Failed" severity FAILURE;
        assert s_Mem_We     = '1' report "Test Case 4 Failed" severity FAILURE;
        assert s_Jump       = '0' report "Test Case 4 Failed" severity FAILURE;
        assert s_MemToReg   = '0' report "Test Case 4 Failed" severity FAILURE;
        assert s_Reg_WE     = '0' report "Test Case 4 Failed" severity FAILURE;
        assert s_Branch     = '0' report "Test Case 4 Failed" severity FAILURE;

        -- Test Case 5
        s_i_opCode          <= OPCODE_BEQ;
        wait for clock;
        assert s_ALU_Src    = '0' report "Test Case 5 Failed" severity FAILURE;
        assert s_Mem_We     = '0' report "Test Case 5 Failed" severity FAILURE;
        assert s_Jump       = '0' report "Test Case 5 Failed" severity FAILURE;
        assert s_MemToReg   = '0' report "Test Case 5 Failed" severity FAILURE;
        assert s_Reg_WE     = '0' report "Test Case 5 Failed" severity FAILURE;
        assert s_Branch     = '1' report "Test Case 5 Failed" severity FAILURE;

        -- Test Case 6
        s_i_opCode          <= OPCODE_JAL;
        wait for clock;
        assert s_ALU_Src    = '1' report "Test Case 6 Failed" severity FAILURE;
        assert s_Mem_We     = '0' report "Test Case 6 Failed" severity FAILURE;
        assert s_Jump       = '1' report "Test Case 6 Failed" severity FAILURE;
        assert s_MemToReg   = '0' report "Test Case 6 Failed" severity FAILURE;
        assert s_Reg_WE     = '1' report "Test Case 6 Failed" severity FAILURE;
        assert s_Branch     = '0' report "Test Case 6 Failed" severity FAILURE;

        -- Test Case 7
        s_i_opCode          <= OPCODE_JALR;
        wait for clock;
        assert s_ALU_Src    = '1' report "Test Case 7 Failed" severity FAILURE;
        assert s_Mem_We     = '0' report "Test Case 7 Failed" severity FAILURE;
        assert s_Jump       = '1' report "Test Case 7 Failed" severity FAILURE;
        assert s_MemToReg   = '0' report "Test Case 7 Failed" severity FAILURE;
        assert s_Reg_WE     = '1' report "Test Case 7 Failed" severity FAILURE;
        assert s_Branch     = '0' report "Test Case 7 Failed" severity FAILURE;

        wait;
    end process;

end behaviour ; -- behaviour
