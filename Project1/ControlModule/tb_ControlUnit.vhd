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
            
            --These have not been assigned   
            ALU_OP      : out std_logic_vector(2 downto 0)
        );
    end component;

    s_i_opCode      : std_logic_vector(6 downto 0);
    s_i_funt7_imm   : std_logic_vector(6 downto 0) := "000000";
    s_ALU_Src       : std_logic;
    s_Mem_We        : std_logic;
    s_Jump          : std_logic;
    s_MemToReg      : std_logic;
    s_Reg_WE        : std_logic;
    s_Branch        : std_logic;

begin

    testbench : ControlUnit
        port map(
            opCode      : in std_logic_vector(6 downto 0),
            funt7_imm   : in std_logic_vector(6 downto 0),
            ALU_Src     : out std_logic,
            Mem_We      : out std_logic,
            Jump        : out std_logic,
            MemToReg    : out std_logic,
            Reg_WE      : out std_logic,
            Branch      : out std_logic,
            ALU_OP      : out std_logic_vector(2 downto 0)
        );

    tests : process
    begin
        wait for (clock / 4);

        -- Base State
        s_i_opCode      <= "000000";
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
    
        -- Test Case 2
        s_i_opCode      <= OPCODE_ADDI;
        wait for clock;
        assert s_ALU_Src = '0' report "Test Case 2 Failed" severity FAILURE;

        wait;
    end process;

end behaviour ; -- behaviour
