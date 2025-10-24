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
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

component ControlUnit is
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
        HaltProg    : out std_logic;
        ALU_OP      : out std_logic_vector(ALU_OP_SIZE-1 downto 0));

end component;

component ALU is
  port(
      i_A : in std_logic_vector(31 downto 0);
      i_B : in std_logic_vector(31 downto 0);

      i_OutSel : in std_logic;
      i_ModSel : in std_logic_vector(1 downto 0);

      i_OppSel : in std_logic_vector(1 downto 0);

      o_Result : out std_logic_vector(31 downto 0);
      o_output : out std_logic_vector(31 downto 0);

      f_ovflw : out std_logic;
      f_zero : out std_logic;
      f_negative : out std_logic
  );
end component;

Component ALU_Control is
    port(
        i_Funct3 : in std_logic_vector(2 downto 0);
        i_Funct7 : in std_logic_vector(6 downto 0);

        o_OutSel : out std_logic;
        o_ModuleSelect : out std_logic_vector(1 downto 0);
        o_OperationSelect : out std_logic_vector(1 downto 0)
    );
end component;



component RegFile is
    port(	clock	: in std_logic;
        reset	: in std_logic;

        RS1Sel	: in std_logic_vector(4 downto 0);
        RS1	: out std_logic_vector(31 downto 0);

        RS2Sel	: in std_logic_vector(4 downto 0);
        RS2	: out std_logic_vector(31 downto 0);

        WrEn	: in std_logic;
        RdSel	: in std_logic_vector(4 downto 0);
        Rd	: in std_logic_vector(31 downto 0));
end component;

component mux2t1_N is
  generic(N : integer);
  port(	i_S          : in std_logic;
      i_D0         : in std_logic_vector(N-1 downto 0);
      i_D1         : in std_logic_vector(N-1 downto 0);
      o_O          : out std_logic_vector(N-1 downto 0));
end component;

component BitExtender20t32
	port(	i_sw	: in std_logic;
		i_20bit	: in std_logic_vector(19 downto 0);
		o_32bit	: out std_logic_vector(31 downto 0));
end component;

--Program Counter
component ProgramCounterSimple is
    generic(ADD_SIZE	: positive);
    port(   i_CLK  	: in std_logic;
            i_RST	: in std_logic;
            i_halt	: in std_logic;
            i_nextInst	: in std_logic_vector(ADD_SIZE-1 downto 0);
            o_CurrInst 	: out std_logic_vector(ADD_SIZE-1 downto 0));
end component;

component BranchDecoder is
  port( i_branchEn  : in std_logic;
        i_funct3    : in std_logic_vector(2 downto 0);
        i_FlagZero  : in std_logic;
        i_FlagNeg   : in std_logic;
        o_branch    : out std_logic);
end  component;

component Iterator is
  generic(DATA_WIDTH: integer);
  port(
    i_instrNum  :   in std_logic_vector(DATA_WIDTH-1 downto 0);
    i_OffsetCnt :   in std_logic_vector(DATA_WIDTH-1 downto 0);
    i_branch    : in std_logic;
    i_jump      : in std_logic;
    o_nextInst  : out std_logic_vector(DATA_WIDTH-1 downto 0));

end component;




--Signals
  --Control
signal s_ALU_Src  : std_logic;
signal s_Jump     : std_logic;
signal s_memToReg : std_logic;
signal s_branchEn : std_logic;
--signal s_ALU_OP   : std_logic_vector(3 downto 0);
  --Register
signal s_RS1Addr  : std_logic_vector(4 downto 0);
signal s_RS1Data  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_RS2Addr  : std_logic_vector(4 downto 0);
signal s_RS2Data  : std_logic_vector(DATA_WIDTH-1 downto 0);

  --B value Mux
signal s_immExt   : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_ALU_B    : std_logic_vector(DATA_WIDTH-1 downto 0);

--Iterator Signals
signal s_BranchCode : std_logic;

--ALU Signals
signal s_OppSel    : std_logic_vector(1 downto 0);
signal s_ALU_Out   : std_logic_vector(DATA_WIDTH-1 downto 0);

  --Temporary Signals
signal s_OutSel  : std_logic;
signal s_ModSel    : std_logic_vector(1 downto 0);

  --ALU Flags
signal s_FlagZero   : std_logic;
signal s_FlagNeg    : std_logic;
signal s_Flag_Ovflw  : std_logic;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
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


  --Fetch Components
  --Program Counter
  ProgramCounter: ProgramCounterSimple
      generic map(ADD_SIZE  => DATA_WIDTH)
      port map(   i_CLK  => iCLK,
                  i_RST  => iRST,
                  i_halt  => s_Halt,
                  i_nextInst => s_NextInstAddr,
                  o_CurrInst  => s_iMemAddr);

  DECODER: BranchDecoder
    port map(
        i_branchEn  => s_branchEn,
        i_funct3    => s_Inst(14 downto 12),
        i_FlagZero  => s_FlagZero,
        i_FlagNeg   => s_FlagNeg,
        o_branch    => s_BranchCode);

  g_Iterator: Iterator
    generic map(DATA_WIDTH => 32)
    port map(   i_instrNum => s_iMemAddr,
                i_OffsetCnt => s_immExt,
                i_branch    => s_BranchCode,
                i_jump      => s_Jump,
                o_nextInst => s_NextInstAddr);


  --Control Components
  Control : ControlUnit
    generic map (ALU_OP_SIZE => 4)
    port map(
        opCode      => s_Inst(6 downto 0),
        ALU_Src     => s_ALU_Src,
        Mem_We      => s_DMemWr,
        Jump        => s_Jump,
        MemToReg    => s_memToReg, --Write a memory value into a register
        Reg_WE      => s_RegWr,
        Branch      => s_branchEn,
        HaltProg    => s_Halt
        --ALU_OP      => s_ALU_OP
    );

    ALU_Module : ALU
        port map(
            i_A         => s_RS1Data,
            i_B         => s_ALU_B,
            i_OutSel    => s_OutSel,
            i_ModSel    => s_ModSel,
            i_OppSel    => s_OppSel,
            o_Result    => s_ALU_Out,
            o_output    => oALUOut,
            f_ovflw     => s_Flag_Ovflw,
            f_zero      => s_FlagZero,
            f_negative  => s_FlagNeg);

    ALU_Control_Module: ALU_Control
      port map(
        i_Funct3  => s_Inst(14 downto 12),
        i_Funct7  => s_Inst(31 downto 25),
        o_OutSel  => s_OutSel,
        o_ModuleSelect => s_ModSel,
        o_OperationSelect => s_OppSel
      );
  g_Reg:  RegFile
    port map(  
      clock   => iCLK,
      reset   => iRST,

      RS1Sel  => s_RS1Addr,
      RS1     => s_RS1Data,

      RS2Sel  => s_RS2Addr,
      RS2     => s_RS2Data,
      
      WrEn    => s_RegWr,
      RdSel   => s_RegWrAddr,
      Rd      => s_RegWrData
    );

  ImmExtender:  BitExtender20t32
    port map(
      i_sw  => s_Inst(DATA_WIDTH - 1),
      i_20bit => s_Inst(DATA_WIDTH-1 downto 12),
      o_32bit => s_immExt
    );

  bValMux:  mux2t1_N
    generic map(N => DATA_WIDTH-1)  
    port map(
      i_S => s_ALU_Src,
      i_D0 => s_RS2Data,
      i_D1 => s_immExt,
      o_O => s_ALU_B
    );

  DestMux: mux2t1_N
      generic map(N => DATA_WIDTH-1)
      port map(
        i_S => s_memToReg,
        i_D0 => s_DMemAddr,
        i_D1 => s_DmemOut,
        o_O => s_RegWrData
      );

end structure;