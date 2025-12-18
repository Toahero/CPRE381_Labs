library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISCV_types.t_IFID;
use work.RISCV_types.t_IDEX;
use work.RISCV_types.t_EXMEM;
use work.RISCV_types.t_MEMWB;

use work.RISCV_types.NOP;
use work.RISCV_types.ZERO;


entity tb_Registers is
    generic(
        gCLK_HPER   : time := 10 ns
    );
end tb_Registers;

architecture mixed of tb_Registers is
    component Buffer_IFID is
        port(
            i_Clock                 : in  std_logic;
            i_Reset                 : in  std_logic;
            i_WriteEnable           : in  std_logic;
            i_NOP                   : in  std_logic;

            i_Next                  : in  t_IFID;
            o_Current               : out t_IFID
        );
    end component;

    component Buffer_IDEX is
        port(
            i_Clock                 : in  std_logic;
            i_Reset                 : in  std_logic;
            i_WriteEnable           : in  std_logic;

            i_Next                  : in  t_IDEX;
            o_Current               : out t_IDEX
        );
    end component;

    component Buffer_EXMEM is
        port(
            i_Clock             : in  std_logic;
            i_Reset             : in  std_logic;
            i_WriteEnable       : in  std_logic;
            i_Next              : in  t_EXMEM;
            o_Current           : out t_EXMEM
        );
    end component;

    component Buffer_MEMWB is
        port(
            i_Clock                 : in  std_logic;
            i_Reset                 : in  std_logic;
            i_WriteEnable           : in  std_logic;

            i_Next                  : in  t_MEMWB;
            o_Current               : out t_MEMWB
        );
    end component;

    signal CLK              : std_logic;

    signal s_IFID_Reset     : std_logic;
    signal s_IDEX_Reset     : std_logic;
    signal s_EXMEM_Reset    : std_logic;
    signal s_MEMWB_Reset    : std_logic;

    signal s_IFID_WrEn      : std_logic;
    signal s_IDEX_WrEn      : std_logic;
    signal s_EXMEM_WrEn     : std_logic;
    signal s_MEMWB_WrEn     : std_logic;

    signal s_nop_trigger    : std_logic := '0';

    signal s_InstructionIn  : std_logic_vector(31 downto 0) := x"00000000";
    signal s_InstructionOut : std_logic_vector(31 downto 0) := x"00000000";

    signal s_IFID_IN        : t_IFID;
    signal s_IFID_OUT       : t_IFID;

    signal s_IDEX_IN        : t_IDEX;
    signal s_IDEX_OUT       : t_IDEX;

    signal s_EXMEM_IN       : t_EXMEM;
    signal s_EXMEM_OUT      : t_EXMEM;

    signal s_MEMWB_IN       : t_MEMWB;
    signal s_MEMWB_OUT      : t_MEMWB;

begin

    s_nop_trigger <= '0';
    s_IFID_IN.Instruction <= s_InstructionIn;
    s_IFID_IN.ProgramCounter <= x"00000000";

    IFID_REGISTER       : Buffer_IFID
        port map(
            i_Clock              => CLK,
            i_Reset              => s_IFID_Reset,
            i_WriteEnable        => s_IFID_WrEn,
            i_NOP                => s_nop_trigger,

            i_Next               => s_IFID_IN,
            o_Current            => s_IFID_OUT
        );


    s_IDEX_IN.BranchOrJump  <= '0';
    s_IDEX_IN.Mem_We        <= '0';
    s_IDEX_IN.MemToReg      <= '0';
    s_IDEX_IN.Reg_WE        <= '0';
    s_IDEX_IN.HaltProg      <= '0';
    s_IDEX_IN.ALU_Operand1  <= x"00000000";
    s_IDEX_IN.ALU_Operand2  <= x"00000000";
    s_IDEX_IN.RS2           <= x"00000000";
    s_IDEX_IN.Instruction   <= s_IFID_OUT.Instruction;
    s_IDEX_IN.ProgramCounter<= s_IFID_OUT.ProgramCounter;

    IDEX_REGISTER       : Buffer_IDEX
        port map(
            i_Clock             => CLK,
            i_Reset             => s_IDEX_Reset,
            i_WriteEnable       => s_IDEX_WrEn,
            
            i_Next              => s_IDEX_IN,
            o_Current           => s_IDEX_OUT
        );

    s_EXMEM_IN.Instruction  <= s_IDEX_OUT.Instruction;

    EXMEM_REGISTER      : Buffer_EXMEM
        port map(
            i_Clock             => CLK,
            i_Reset             => s_EXMEM_Reset,
            i_WriteEnable       => s_EXMEM_WrEn,

            i_Next              => s_EXMEM_IN,
            o_Current           => s_EXMEM_OUT
        );

    s_MEMWB_IN.Instruction  <= s_EXMEM_OUT.Instruction;

    MEMWB_REGISTER      : Buffer_MEMWB
        port map(
            i_Clock             => CLK,
            i_Reset             => s_MEMWB_Reset,
            i_WriteEnable       => s_MEMWB_WrEn,

            i_Next              => s_MEMWB_IN,
            o_Current           => s_MEMWB_OUT
        );

    s_InstructionOut <= s_MEMWB_OUT.Instruction;


    P_CLK: process
        begin
            CLK <= '1';         -- clock starts at 1
            wait for gCLK_HPER; -- after half a cycle

            CLK <= '0';         -- clock becomes a 0 (negative edge)
            wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
        end process;

    P_TEST_Instructions: process
        begin
            s_IFID_WrEn     <= '1';
            s_IDEX_WrEn     <= '1';
            s_EXMEM_WrEn    <= '1';
            s_MEMWB_WrEn    <= '1';

            wait for gCLK_HPER/2; --Change inputs on clk midpoints
            
            --Reset Register values
            s_IFID_Reset    <= '1';
            s_IDEX_Reset    <= '1';
            s_EXMEM_Reset   <= '1';
            s_MEMWB_Reset   <= '1';
            wait for 2*gCLK_HPER;
            s_IFID_Reset    <= '0';
            s_IDEX_Reset    <= '0';
            s_EXMEM_Reset   <= '0';
            s_MEMWB_Reset   <= '0';
            wait for 2*gCLK_HPER;


            s_InstructionIn <= x"00000000";
            wait for 2*gCLK_HPER;

            s_InstructionIn <= x"FFFFFFFF";
            wait for 2*gCLK_HPER;

            s_nop_trigger <= '1';
            wait for 2*gCLK_HPER;
            
            s_InstructionIn <= x"11111111";
            s_nop_trigger <= '0';
            wait for 2*gCLK_HPER;
            
            s_InstructionIn <= x"22222222";
            s_MEMWB_Reset <= '1';
            wait for gCLK_HPER*2;

            s_InstructionIn <= x"33333333";
            s_MEMWB_Reset <= '0';
            s_EXMEM_Reset <= '1';
            wait for gCLK_HPER*2;
            
            s_InstructionIn <= x"44444444";
            s_EXMEM_Reset <= '0';
            s_IDEX_Reset <= '1';
            wait for gCLK_HPER*2;
            
            s_InstructionIn <= x"55555555";
            s_IDEX_Reset <= '0';
            s_IFID_Reset <= '1';
            wait for gCLK_HPER*2;
            
            s_InstructionIn <= x"66666666";
            s_IFID_Reset <= '0';
            s_MEMWB_WrEn     <= '0';
            wait for gCLK_HPER*2;
            
            s_InstructionIn <= x"77777777";
            s_EXMEM_WrEn <= '0';
            wait for gCLK_HPER*2;
            
            s_InstructionIn <= x"88888888";
            s_IDEX_WrEn <= '0';
            wait for gCLK_HPER*2;
            
            s_InstructionIn <= x"99999999";
            s_IFID_WrEn <= '0';
            wait for gCLK_HPER*2;
            wait;
    end process;
end mixed;