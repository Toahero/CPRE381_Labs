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
  generic(N : integer := DATA_WIDTH);
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

  component DMEMSignExtender is
    port(
      i_Data                            : in std_logic_vector(31 downto 0);
      i_Funct3                          : in std_logic_vector(2 downto 0);

      o_SignExtendedDMEM                : out std_logic_vector(31 downto 0)
    );
  end component;
  signal s_SignExtendedDMEM             : std_logic_vector(31 downto 0);

  component InstructionAddressHolder is
      generic(
          ADDR_WIDTH : integer := 32
      );
      port(
          i_Clock                       : in  std_logic;
          i_Reset                       : in  std_logic;
          i_NextInstructionAddress      : in  std_logic_vector((ADDR_WIDTH - 1) downto 0);
          i_Halt                        : in std_logic;
  
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
  signal s_RS1                          : std_logic_vector(31 downto 0);
  signal s_RS2                          : std_logic_vector(31 downto 0);
  signal s_RD_Data                      : std_logic_vector(31 downto 0);

  component ControlUnit is
    port(
      opCode                            : in  std_logic_vector(6 downto 0);
      
      ALU_Src                           : out std_logic;
      Mem_We                            : out std_logic;
      Jump                              : out std_logic;
      MemToReg                          : out std_logic;
      Reg_WE                            : out std_logic;
      Branch                            : out std_logic;
      HaltProg                          : out std_logic
    );
  end component;
  signal s_Control_ALU_Src              : std_logic;
  signal s_Control_Mem_We               : std_logic;
  signal s_Control_Jump                 : std_logic;
  signal s_Control_MemToReg             : std_logic;
  signal s_Control_Reg_WE               : std_logic;
  signal s_Control_Branch               : std_logic;
  signal s_Control_HaltProg             : std_logic;

  component ImmediateExtender is
    port(
      i_instruction                     : in  std_logic_vector(31 downto 0);
      o_output                          : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux2t1_N is
    generic(
      N                                 : integer := 16 -- Generic of type integer for input/output data width. Default value is 32.
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

      o_aOverride                       : out std_logic;
      o_OvrValue                        : out std_logic_vector(31 downto 0);
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

  signal s_ALU_Operand1                 : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_ALU_Operand2                 : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_AOverride                    : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_BOverride                    : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_AOverrideEnable              : std_logic;
  signal s_BOverrideEnable              : std_logic;
  signal s_ALU_Result                   : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_ALU_ModuleSelect             : std_logic_vector(1 downto 0);
  signal s_ALU_OperationSelect          : std_logic_vector(1 downto 0);
  signal s_ALU_BranchCondition          : std_logic_vector(2 downto 0);
  signal f_ALU_Overflow                 : std_logic;
  signal f_ALU_Zero                     : std_logic;
  signal f_ALU_Negative                 : std_logic;


  signal s_ProgramCounterOut            : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_StdNextInstAddr              : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_ImmediateValue               : std_logic_vector(DATA_WIDTH - 1 downto 0);


  component HACK is
    port (
      input_vec  : in  std_logic_vector(31 downto 0);
      output_vec : out std_logic_vector(31 downto 0)
    );
  end component;
  signal s_Instruction          : std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal s_DataMemory           : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

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
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
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
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment!

  g_DMEMSignExtender : DMEMSignExtender
    port map(
      i_Data                            => s_DataMemory,
      i_Funct3                          => s_Instruction(14 downto 12),

      o_SignExtendedDMEM                => s_SignExtendedDMEM
    );

  s_NextInstAddr                        <= s_ProgramCounterOut;

  g_ProgramCounter : InstructionAddressHolder
      generic map(
          ADDR_WIDTH                    => 32
      )
      port map(
          i_Clock                       => iCLK,
          i_Reset                       => iRST,
          i_NextInstructionAddress      => s_StdNextInstAddr,
          i_Halt                        => s_Halt,

          o_CurrentInstructionAddress   => s_ProgramCounterOut
      );

  g_ProgramCounterConstAdder : AddSub
      generic map(
          WIDTH                         => 32
      )
      port map(
          i_A                           => s_ProgramCounterOut,
          i_B                           => x"00000004",
          n_Add_Sub                     => '0',
          o_S                           => s_StdNextInstAddr,
          o_C                           => open
      );

  g_ControlUnit : ControlUnit
    port map(
      opCode                            => s_Instruction(6 downto 0),

      ALU_Src                           => s_Control_ALU_Src,
      Mem_We                            => s_Control_Mem_We,
      Jump                              => s_Control_Jump,
      MemToReg                          => s_Control_MemToReg,
      Reg_WE                            => s_Control_Reg_WE,
      Branch                            => s_Control_Branch,
      HaltProg                          => s_Control_HaltProg
    );
  s_Halt                                <= s_Control_HaltProg;
  s_DMemWr                              <= s_Control_Mem_We;

  g_ImmediateGeneration : ImmediateExtender
    port map(
      i_instruction                     => s_Instruction,
      o_output                          => s_ImmediateValue
    );

  g_Mux_ALU_Operand2 : mux2t1_N
    generic map(
      N                                 => 32 -- Generic of type integer for input/output data width. Default value is 32.
    )
    port map(
      i_S                               => s_Control_ALU_Src,
      i_D0                              => s_RS2,
      i_D1                              => s_ImmediateValue,
      o_O                               => s_ALU_Operand2
    );

  g_RegisterFile : RegFile
    port map(
      clock	                            => iCLK,
      reset	                            => iRST,

      RS1Sel	                          => s_Instruction(19 downto 15),
      RS1                               => s_RS1,

      RS2Sel	                          => s_Instruction(24 downto 20),
      RS2                               => s_RS2,

      WrEn	                            => s_Control_Reg_We,
      RdSel	                            => s_RegWrAddr,
      Rd                                => s_RD_Data
    );
  s_RegWr                               <= s_Control_Reg_WE;
  s_RegWrAddr                           <= s_Instruction(11 downto 7);
  s_RegWrData                           <= s_RD_Data;
  s_DMemData                            <= s_RS2;

  g_ALUControl : ALU_Control
    port map(
      i_Opcode                          => s_Instruction(6  downto 0 ),
      i_Funct3                          => s_Instruction(14 downto 12),
      i_Funct7                          => s_Instruction(31 downto 25),
      i_PCAddr                          => s_ProgramCounterOut,

      o_aOverride                       => s_AOverrideEnable,
      o_OvrValue                        => s_AOverride,
      o_ModuleSelect                    => s_ALU_ModuleSelect,
      o_OperationSelect                 => s_ALU_OperationSelect,
      o_Funct3Passthrough               => s_ALU_BranchCondition
    );

  s_ALU_Operand1                        <= s_RS1;
  g_ALU : ALU
    port map(
        i_A                             => s_ALU_Operand1,
        i_B                             => s_ALU_Operand2,
        i_AOverride                     => s_AOverride,
        i_BOverride                     => x"00000000",
        i_AOverrideEnable               => s_AOverrideEnable,
        i_BOverrideEnable               => '0',

        i_OutSel                        => '0',
        i_ModSel                        => s_ALU_ModuleSelect,
        i_OppSel                        => s_ALU_OperationSelect,

        i_BranchCond                    => s_ALU_BranchCondition,

        o_Result                        => open,
        o_output                        => s_ALU_Result,
        f_ovflw                         => f_ALU_Overflow,
        f_zero                          => f_ALU_Zero,
        f_negative                      => f_ALU_Negative
    );
  oALUOut                               <= s_ALU_Result;
  s_DMemAddr                            <= s_ALU_Result;

  g_RegisterDataSource : mux2t1_N
    generic map(
      N                                 => 32
    )
    port map(
      i_S                               => s_Control_MemToReg,
      i_D0                              => s_ALU_Result,
      i_D1                              => s_SignExtendedDMEM,
      o_O                               => s_RD_Data
    );

end structure;
