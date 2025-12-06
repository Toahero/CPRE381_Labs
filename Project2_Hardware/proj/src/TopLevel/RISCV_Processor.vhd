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
      ADDR_WIDTH                        : integer := 32
    );
    port(
      i_Clock                           : in std_logic;
      i_Reset                           : in std_logic;
      i_NextInstructionAddress          : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
      i_Halt                            : in std_logic;
      i_Pause                           : in std_logic;
      o_CurrentInstructionAddress       : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
    );
  end component;


  component AddSub is
    generic(
      WIDTH                             : integer := 8
    );
    port(
      i_A                               : in  std_logic_vector(WIDTH - 1 downto 0);
      i_B                               : in  std_logic_vector(WIDTH - 1 downto 0);
      n_Add_Sub                         : in  std_logic;

      o_S                               : out std_logic_vector(WIDTH - 1 downto 0);
      o_C                               : out std_logic
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
      i_Opcode                          : in  std_logic_vector(6 downto 0);
      i_Funct3                          : in  std_logic_vector(2 downto 0);
      i_Funct7                          : in  std_logic_vector(6 downto 0);
      i_PCAddr                          : in  std_logic_vector(31 downto 0);
      o_AOverride                       : out std_logic_vector(31 downto 0);
      o_BOverride                       : out std_logic_vector(31 downto 0);
      o_BOverrideEnable                 : out std_logic;
      o_AOverrideEnable                 : out std_logic;
      o_ModuleSelect                    : out std_logic_vector(1 downto 0);
      o_OperationSelect                 : out std_logic_vector(1 downto 0);
      o_Funct3Passthrough               : out std_logic_vector(2 downto 0)
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
      i_NOP                             : in  std_logic;
  
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
      i_Clock                           : in  std_logic;
      i_Reset                           : in  std_logic;
      i_WriteEnable                     : in  std_logic;

      i_Next                            : in  t_EXMEM;
      o_Current                         : out t_EXMEM
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

  component HazardDetectionUnit is
    port(
      i_IF_Instruction                  : in  std_logic_vector(31 downto 0);
      i_ID_Instruction                  : in  std_logic_vector(31 downto 0);
      i_EX_Instruction                  : in  std_logic_vector(31 downto 0);
      i_MEM_Instruction                 : in  std_logic_vector(31 downto 0);
      i_WB_Instruction                  : in  std_logic_vector(31 downto 0);
  
      o_NOP                             : out std_logic;
      o_IFID_Reset                      : out std_logic;
      o_IFID_WriteEnable                : out std_logic;
      o_IDEX_Reset                      : out std_logic;
      o_IDEX_WriteEnable                : out std_logic;
      o_EXMEM_Reset                     : out std_logic;
      o_EXMEM_WriteEnable               : out std_logic;
      o_MEMWB_Reset                     : out std_logic;
      o_MEMWB_WriteEnable               : out std_logic
    );
  end component;

  signal s_CycleTracker                 : integer := 0;
  signal s_DataMemory                   : std_logic_vector(31 downto 0);
  signal s_Instruction                  : std_logic_vector(31 downto 0);

  -- Buffers
  signal s_IFID_Next                    : t_IFID;
  signal s_IFID_Current                 : t_IFID;
  signal s_IFID_WriteEnable             : std_logic;
  signal s_IFID_Reset                   : std_logic;
  signal s_IDEX_Next                    : t_IDEX;
  signal s_IDEX_Current                 : t_IDEX;
  signal s_IDEX_WriteEnable             : std_logic;
  signal s_IDEX_Reset                   : std_logic;
  signal s_EXMEM_Next                   : t_EXMEM;
  signal s_EXMEM_Current                : t_EXMEM;
  signal s_EXMEM_WriteEnable            : std_logic;
  signal s_EXMEM_Reset                  : std_logic;
  signal s_MEMWB_Next                   : t_MEMWB;
  signal s_MEMWB_Current                : t_MEMWB;
  signal s_MEMWB_WriteEnable            : std_logic;
  signal s_MEMWB_Reset                  : std_logic;

  -- Hazard Detection and Forwarding
  signal s_NOP                          : std_logic;

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
  signal s_ID_Control_PCOffsetSource    : std_logic;

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
    generic map(ADDR_WIDTH => 10,
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
    generic map(ADDR_WIDTH => 10,
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
      i_S                               => s_ID_JumpOrBranch,
      i_D0                              => s_StdNextPC,
      i_D1                              => s_JumpOrBranchNextPC,
      o_O                               => s_NextInstructionAddress
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
      i_Pause                           => s_NOP,
      o_CurrentInstructionAddress       => s_IF_InstructionAddress
    );
  s_Halt                                <= s_MEMWB_Current.HaltProg;

  g_StdProgramCounterAdder : AddSub
    generic map(
      WIDTH                             => 32
    )
    port map(
      i_A                               => s_IF_InstructionAddress,
      i_B                               => x"00000004",
      n_Add_Sub                         => '0',
      o_S                               => s_StdNextPC,
      o_C                               => open
    );

  g_HazardDetectionUnit : HazardDetectionUnit
    port map(
      i_IF_Instruction                  => s_IFID_Next.Instruction,
      i_ID_Instruction                  => s_IFID_Current.Instruction,
      i_EX_Instruction                  => s_IDEX_Current.Instruction,
      i_MEM_Instruction                 => s_EXMEM_Current.Instruction,
      i_WB_Instruction                  => s_MEMWB_Current.Instruction,

      o_NOP                             => s_NOP,
      o_IFID_Reset                      => s_IFID_Reset,
      o_IFID_WriteEnable                => s_IFID_WriteEnable,
      o_IDEX_Reset                      => s_IDEX_Reset,
      o_IDEX_WriteEnable                => s_IDEX_WriteEnable,
      o_EXMEM_Reset                     => s_EXMEM_Reset,
      o_EXMEM_WriteEnable               => s_EXMEM_WriteEnable,
      o_MEMWB_Reset                     => s_MEMWB_Reset,
      o_MEMWB_WriteEnable               => s_MEMWB_WriteEnable 
    );

  s_NextInstAddr                        <= s_IF_InstructionAddress;
  s_IFID_Next.Instruction               <= s_Instruction;
  s_IFID_Next.ProgramCounter            <= s_IF_InstructionAddress;

  g_Buffer_IFID : Buffer_IFID
    port map(
      i_Clock                           => iCLK,
      i_Reset                           => iRST or s_IFID_Reset,
      i_WriteEnable                     => s_IFID_WriteEnable,
      i_NOP                             => s_NOP,
      i_Next                            => s_IFID_Next,
      o_Current                         => s_IFID_Current
    );

  g_ControlUnit : ControlUnit
    port map (
      i_inst                            => s_IFID_Current.Instruction,
      ALU_Src                           => s_ID_Control_ALUSource,
      Mem_We                            => s_IDEX_Next.Mem_We,
      Jump                              => s_ID_Control_Jump,
      MemToReg                          => s_IDEX_Next.MemToReg,
      Reg_WE                            => s_IDEX_Next.Reg_WE,
      Branch                            => s_ID_Control_BranchEnable,
      HaltProg                          => s_IDEX_Next.HaltProg,
      PCOffsetSource                    => s_ID_Control_PCOffsetSource
    );

  g_RegisterFile : RegFile
    port map(
      clock	                            => iCLK,
      reset	                            => iRST,
      RS1Sel	                          => s_IFID_Current.Instruction(19 downto 15),
      RS1                               => s_ID_RS1,
      RS2Sel	                          => s_IFID_Current.Instruction(24 downto 20),
      RS2                               => s_ID_RS2,
      WrEn	                            => s_MEMWB_Current.Reg_WE,
      RdSel	                            => s_MEMWB_Current.Instruction(11 downto 7),
      Rd                                => s_WB_RegisterData
    );

  s_RegWr                               <= s_MEMWB_Current.Reg_WE;                    -- TODO: use this signal as the final active high write enable input to the register file
  s_RegWrAddr                           <= s_MEMWB_Current.Instruction(11 downto 7);  -- TODO: use this signal as the final destination register address input
  s_RegWrData                           <= s_WB_RegisterData;                         -- TODO: use this signal as the final data memory data input

  g_ImmediateExtender : ImmediateExtender
    port map(
      i_instruction                     => s_IFID_Current.Instruction,
      o_output                          => s_ID_Immediate
    );

  g_Mux_ALU_Operand2 : mux2t1_N
    generic map(
      N                                 => 32
    )
    port map(
      i_S                               => s_ID_Control_ALUSource,
      i_D0                              => s_ID_RS2,
      i_D1                              => s_ID_Immediate,
      o_O                               => s_IDEX_Next.ALU_Operand2
    );

  g_BranchCompare : Compare
    port map(
      i_A                               => s_ID_RS1,
      i_B                               => s_ID_RS2,
      i_slt_Unsigned                    => '0',
      i_BranchCondition                 => s_IFID_Current.Instruction(14 downto 12),
      o_Result_slt                      => open,
      o_Result_Branch                   => s_ID_CompareBranchResult
    );
  
  s_ID_JumpOrBranch                     <= (s_ID_Control_Jump or (s_ID_CompareBranchResult and s_ID_Control_BranchEnable));

  g_Mux_PC_Offset : mux2t1_N
    generic map(
      N                                 => 32
    )
    port map(
      i_S                               => s_ID_Control_PCOffsetSource,
      i_D0                              => s_IFID_Current.ProgramCounter,
      i_D1                              => s_ID_RS1,
      o_O                               => s_ID_PC_Offset
    );
  
  g_JumpOrBranchPCAdder : AddSub
    generic map(
        WIDTH                         => 32
    )
    port map(
      i_A                             => s_ID_PC_Offset,
      i_B                             => s_ID_Immediate,
      n_Add_Sub                       => '0',
      o_S                             => s_JumpOrBranchNextPC,
      o_C                             => open
    );

  s_IDEX_Next.ALU_Operand1            <= s_ID_RS1;
  s_IDEX_Next.RS2                     <= s_ID_RS2;
  s_IDEX_Next.Instruction             <= s_IFID_Current.Instruction;
  s_IDEX_Next.ProgramCounter          <= s_IFID_Current.ProgramCounter;

  g_Buffer_IDEX : Buffer_IDEX
    port map(
      i_Clock                         => iCLK,
      i_Reset                         => iRST or s_IDEX_Reset,
      i_WriteEnable                   => s_IDEX_WriteEnable,
      i_Next                          => s_IDEX_Next,
      o_Current                       => s_IDEX_Current
    );
  
  g_ALU_Control : ALU_Control
    port map(
      i_Opcode                        => s_IDEX_Current.Instruction(6 downto 0),
      i_Funct3                        => s_IDEX_Current.Instruction(14 downto 12),
      i_Funct7                        => s_IDEX_Current.Instruction(31 downto 25),
      i_PCAddr                        => s_IDEX_Current.ProgramCounter,
      o_AOverride                     => s_EX_ALU_AOverride,
      o_BOverride                     => s_EX_ALU_BOverride,
      o_AOverrideEnable               => s_EX_ALU_AOverrideEnable,
      o_BOverrideEnable               => s_EX_ALU_BOverrideEnable,
      o_ModuleSelect                  => s_EX_ALU_ModuleSelect,
      o_OperationSelect               => s_EX_ALU_OperationSelect,
      o_Funct3Passthrough             => open
    );

  g_ALU : ALU
    port map(
      i_A                             => s_IDEX_Current.ALU_Operand1,
      i_B                             => s_IDEX_Current.ALU_Operand2,
      i_AOverride                     => s_EX_ALU_AOverride,
      i_BOverride                     => s_EX_ALU_BOverride,
      i_AOverrideEnable               => s_EX_ALU_AOverrideEnable,
      i_BOverrideEnable               => s_EX_ALU_BOverrideEnable,
      i_OutSel                        => '0',
      i_ModSel                        => s_EX_ALU_ModuleSelect,
      i_OppSel                        => s_EX_ALU_OperationSelect,
      i_BranchCond                    => "000",
      o_Result                        => open,
      o_output                        => s_EXMEM_Next.ALU_Output,
      f_ovflw                         => s_Ovfl,
      f_zero                          => open,
      f_negative                      => open,
      f_branch                        => open
    );
  oALUOut                             <= s_EXMEM_Next.ALU_Output;  

  s_EXMEM_Next.Mem_We                 <= s_IDEX_Current.Mem_We;
  s_EXMEM_Next.MemToReg               <= s_IDEX_Current.MemToReg;
  s_EXMEM_Next.Reg_WE                 <= s_IDEX_Current.Reg_WE;
  s_EXMEM_Next.HaltProg               <= s_IDEX_Current.HaltProg;
  s_EXMEM_Next.RS2                    <= s_IDEX_Current.RS2;
  s_EXMEM_Next.Instruction            <= s_IDEX_Current.Instruction;

  g_Buffer_EXMEM : Buffer_EXMEM
    port map(
      i_Clock                         => iCLK,
      i_Reset                         => iRST or s_EXMEM_Reset,
      i_WriteEnable                   => s_EXMEM_WriteEnable,
      i_Next                          => s_EXMEM_Next,
      o_Current                       => s_EXMEM_Current
    );

  s_DMemWr                            <= s_EXMEM_Current.Mem_We;      -- TODO: use this signal as the final active high data memory write enable signal
  s_DMemAddr                          <= s_EXMEM_Current.ALU_Output;  -- TODO: use this signal as the final data memory address input
  s_DMemData                          <= s_EXMEM_Current.RS2;         -- TODO: use this signal as the final data memory data input
  
  s_MEM_DMEM_Raw                      <= s_DataMemory;
  g_DMEMSignExtender : DMEMSignExtender 
    port map(
      i_Data                          => s_MEM_DMEM_Raw,
      i_Funct3                        => s_EXMEM_Current.Instruction(14 downto 12),
      o_SignExtendedDMEM              => s_MEMWB_Next.DMem_Output
    );

  s_MEMWB_Next.MemToReg               <= s_EXMEM_Current.MemToReg;
  s_MEMWB_Next.Reg_WE                 <= s_EXMEM_Current.Reg_WE;
  s_MEMWB_Next.HaltProg               <= s_EXMEM_Current.HaltProg;
  s_MEMWB_Next.ALU_Output             <= s_EXMEM_Current.ALU_Output;
  s_MEMWB_Next.Instruction            <= s_EXMEM_Current.Instruction;

  g_Buffer_MEMWB : Buffer_MEMWB
    port map(
      i_Clock                         => iCLK,
      i_Reset                         => iRST or s_MEMWB_Reset,
      i_WriteEnable                   => s_MEMWB_WriteEnable,
      i_Next                          => s_MEMWB_Next,
      o_Current                       => s_MEMWB_Current
    );

  g_Mux_RegisterWriteData : mux2t1_N
    generic map(
      N                                 => 32
    )
    port map(
      i_S                               => s_MEMWB_Current.MemToReg,
      i_D0                              => s_MEMWB_Current.ALU_Output,
      i_D1                              => s_MEMWB_Current.DMem_Output,
      o_O                               => s_WB_RegisterData
    );

end structure;
