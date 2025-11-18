-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RISCV_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a RISCV_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-- 04/10/2025 by AP::Coverted to RISC-V.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity RISCV_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  RISCV_Processor;

architecture structure of RISCV_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Use WFI with Opcode: 111 0011)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk                           : in  std_logic;
          addr                          : in  std_logic_vector((ADDR_WIDTH-1) downto 0);
          data                          : in  std_logic_vector((DATA_WIDTH-1) downto 0);
          we                            : in  std_logic := '1';
          q                             : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  ------------------------------------------------
  ---               Components                 ---
  ------------------------------------------------

  component DMEMSignExtender is
    port(
      i_Data                            : in std_logic_vector(31 downto 0);
      i_Funct3                          : in std_logic_vector(2 downto 0);

      o_SignExtendedDMEM                : out std_logic_vector(31 downto 0)
    );
  end component;

  component InstructionAddressHolder is
      generic(
          ADDR_WIDTH : integer := 32
      );
      port(
          i_Clock                       : in  std_logic;
          i_Reset                       : in  std_logic;
          i_NextInstructionAddress      : in  std_logic_vector((ADDR_WIDTH - 1) downto 0);
          i_Halt                        : in  std_logic;
  
          o_CurrentInstructionAddress   : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
      );
  end component;

  component AddSub is
      generic(
          WIDTH                         : integer := 8
      );
      port(
          i_A                           : in  std_logic_vector(WIDTH - 1 downto 0);
          i_B                           : in  std_logic_vector(WIDTH - 1 downto 0);
          n_Add_Sub                     : in  std_logic;
  
          o_S                           : out std_logic_vector(WIDTH - 1 downto 0);
          o_C                           : out std_logic
      );
  end component;

  component RegFile is
    port(
      clock	                            : in  std_logic;
      reset	                            : in  std_logic;
  
      RS1Sel	                          : in  std_logic_vector(4 downto 0);
      RS1                               : out std_logic_vector(31 downto 0);
  
      RS2Sel	                          : in  std_logic_vector(4 downto 0);
      RS2                               : out std_logic_vector(31 downto 0);
  
      WrEn	                            : in  std_logic;
      RdSel	                            : in  std_logic_vector(4 downto 0);
      Rd                                : in  std_logic_vector(31 downto 0)
    );
  end component;

  component ControlUnit is
    port(
      i_inst                            : in  std_logic_vector(31 downto 0);
      ALU_Src                           : out std_logic;
      Mem_We                            : out std_logic;
      Jump                              : out std_logic;
      MemToReg                          : out std_logic;
      Reg_WE                            : out std_logic;
      Branch                            : out std_logic;
      HaltProg                          : out std_logic;
      PCOffsetSource                    : out std_logic
    );
  end component;

  component Compare is
    port(
      i_A                               : in  std_logic_vector(31 downto 0);
      i_B                               : in  std_logic_vector(31 downto 0);
      i_slt_Unsigned                    : in  std_logic;
      i_BranchCondition                 : in  std_logic_vector(2 downto 0); -- Funct3
      o_Result_slt                      : out std_logic_vector(31 downto 0);
      o_Result_Branch                   : out std_logic
    );
  end component;

  component ImmediateExtender is
    port(
      i_instruction                     : in  std_logic_vector(31 downto 0);
      o_output                          : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux2t1_N is
    generic(
      N                                 : integer := 16
    );
    port(
        i_S                             : in  std_logic;
        i_D0                            : in  std_logic_vector(N-1 downto 0);
        i_D1                            : in  std_logic_vector(N-1 downto 0);
        o_O                             : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component ALU_Control is
    port(
        i_Opcode                        : in  std_logic_vector(6 downto 0);
        i_Funct3                        : in  std_logic_vector(2 downto 0);
        i_Funct7                        : in  std_logic_vector(6 downto 0);
        i_PCAddr                        : in  std_logic_vector(31 downto 0);
        o_AOverride                     : out std_logic_vector(31 downto 0);
        o_BOverride                     : out std_logic_vector(31 downto 0);
        o_BOverrideEnable               : out std_logic;
        o_AOverrideEnable               : out std_logic;
        o_ModuleSelect                  : out std_logic_vector(1 downto 0);
        o_OperationSelect               : out std_logic_vector(1 downto 0);
        o_Funct3Passthrough             : out std_logic_vector(2 downto 0)
    );
  end component;

  component ALU is
    port(
      i_A                               : in  std_logic_vector(31 downto 0);
      i_B                               : in  std_logic_vector(31 downto 0);
      i_AOverride                       : in  std_logic_vector(31 downto 0);
      i_BOverride                       : in  std_logic_vector(31 downto 0);
      i_BOverrideEnable                 : in  std_logic;
      i_AOverrideEnable                 : in  std_logic;
      i_OutSel                          : in  std_logic;
      i_ModSel                          : in  std_logic_vector(1 downto 0);
      i_OppSel                          : in  std_logic_vector(1 downto 0);
      i_BranchCond                      : in  std_logic_vector(2 downto 0); -- Funct3

      o_Result                          : out std_logic_vector(31 downto 0); -- Unused
      o_output                          : out std_logic_vector(31 downto 0);
      f_ovflw                           : out std_logic;
      f_zero                            : out std_logic;
      f_negative                        : out std_logic;
      f_branch                          : out std_logic
    );
  end component;

  component HACK is
    port (
      input_vec                         : in  std_logic_vector(31 downto 0);
      output_vec                        : out std_logic_vector(31 downto 0)
    );
  end component;

  component Buffer_IFID is
    port(
      i_Clock                           : in  std_logic;
      i_Reset                           : in  std_logic;
      i_WriteEnable                     : in  std_logic;
  
      i_Next                            : in  t_IFID;
      o_Current                         : out t_IFID
    );
  end component;

  component Buffer_IDEX is
    port(
      i_Clock                           : in  std_logic;
      i_Reset                           : in  std_logic;
      i_WriteEnable                     : in  std_logic;
  
      i_Next                            : in  t_IDEX;
      o_Current                         : out t_IDEX
    );
  end component;

  component Buffer_EXMEM is
    port(
      i_Clock                 : in  std_logic;
      i_Reset                 : in  std_logic;
      i_WriteEnable           : in  std_logic;
      i_Next                  : in  t_EXMEM;
      o_Current               : out t_EXMEM
    );
  end component;

  component Buffer_MEMWB is
    port(
      i_Clock                           : in  std_logic;
      i_Reset                           : in  std_logic;
      i_WriteEnable                     : in  std_logic;
  
      i_Next                            : in  t_MEMWB;
      o_Current                         : out t_MEMWB
    );
  end component;

  signal s_CycleTracker                 : integer := 0;
  signal s_DataMemory                   : std_logic_vector(31 downto 0);
  signal s_Instruction                  : std_logic_vector(31 downto 0);

  -- Buffer Signals
  signal s_IFID_Next                    : t_IFID;
  signal s_IFID_Current                 : t_IFID;
  signal s_IDEX_Next                    : t_IDEX;
  signal s_IDEX_Current                 : t_IDEX;
  signal s_EXMEM_Next                    : t_EXMEM;
  signal s_EXMEM_Current                 : t_EXMEM;
  signal s_MEMWB_Next                    : t_MEMWB;
  signal s_MEMWB_Current                 : t_MEMWB;

  -- IF
  signal s_NextInstructionAddress       : std_logic_vector(31 downto 0);
  signal s_IF_InstructionAddress        : std_logic_vector(31 downto 0);
  signal s_StdNextPC                    : std_logic_vector(31 downto 0);
  signal s_JumpOrBranchNextPC           : std_logic_vector(31 downto 0);

  -- ID
  signal s_ID_JumpOrBranch              : std_logic;
  signal s_ID_Immediate                 : std_logic_vector(31 downto 0);
  signal s_ID_RS1                       : std_logic_vector(31 downto 0);
  signal s_ID_RS2                       : std_logic_vector(31 downto 0);
  signal s_ID_Control_ALUSource         : std_logic;
  signal s_ID_PC_Offset                 : std_logic_vector(31 downto 0);
  signal s_ID_CompareBranchResult       : std_logic;
  signal s_ID_Control_BranchEnable      : std_logic;
  signal s_ID_Control_Jump              : std_logic;


  -- EX
  signal s_EX_ALU_AOverride             : std_logic_vector(31 downto 0);
  signal s_EX_ALU_BOverride             : std_logic_vector(31 downto 0);
  signal s_EX_ALU_AOverrideEnable       : std_logic;
  signal s_EX_ALU_BOverrideEnable       : std_logic;
  signal s_EX_ALU_ModuleSelect          : std_logic_vector(1 downto 0);
  signal s_EX_ALU_OperationSelect       : std_logic_vector(1 downto 0);

  -- MEM
  signal s_MEM_DMEM_Raw                 : std_logic_vector(31 downto 0);

  -- WB
  signal s_WB_RegisterData              : std_logic_vector(31 downto 0);

begin

  p_CycleTracker : process(iCLK, s_CycleTracker)
  begin
    if (rising_edge(iCLK)) then
      s_CycleTracker <= (s_CycleTracker + 1);
    end if;
    if (iRST) then
      s_CycleTracker <= 0;
    end if;
  end process; -- p_CycleTracker

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  -- TODO: Ask about this ASAP
  -- The output of the Instruction Memory doesn't work as expected,
  -- 0's output fine, but 1's output as 'X'. This component turns
  -- anything other than '0' into '1', be it 'X', 'U', or anything else.
    g_ImemHack : HACK
        port map(
            input_vec                   => s_Inst,
            output_vec                  => s_Instruction
        );

  IMem: mem
    generic map(ADDR_WIDTH => 32,
                DATA_WIDTH => 32)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
    g_DmemHack : HACK
        port map(
            input_vec                   => s_DMemOut,
            output_vec                  => s_DataMemory
        );

  DMem: mem
    generic map(ADDR_WIDTH => 32,
                DATA_WIDTH => 32)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment!

   g_Mux_NextInstructionAddress : mux2t1_N
    generic map(
      N                                 => 32
    )
    port map(
        i_S                             => s_ID_JumpOrBranch,
        i_D0                            => s_StdNextPC,
        i_D1                            => s_JumpOrBranchNextPC,
        o_O                             => s_NextInstructionAddress
    );

  g_InstructionAddressHolder : InstructionAddressHolder
    generic map(
      ADDR_WIDTH                        => 32
    )
    port map (
      i_Clock                           => iCLK,
      i_Reset                           => iRST,
      i_NextInstructionAddress          => s_NextInstructionAddress,
      i_Halt                            => s_MEMWB_Current.HaltProg,
      o_CurrentInstructionAddress       => s_IF_InstructionAddress
    );
  s_Halt                                <= s_MEMWB_Current.HaltProg;

  g_StdProgramCounterAdder : AddSub
    generic map(
          WIDTH                         => 32
    )
    port map(
          i_A                           => s_IF_InstructionAddress,
          i_B                           => x"00000004",
          n_Add_Sub                     => '0',
          o_S                           => s_StdNextPC,
          o_C                           => open
    );
  s_NextInstAddr                        <= s_IF_InstructionAddress;
  s_IFID_Next.Instruction               <= s_Instruction;
  s_IFID_Next.ProgramCounter            <= s_IF_InstructionAddress;

  


end structure;