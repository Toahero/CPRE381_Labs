-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: RegFile.vhd, addSun_n.vhd, mux2t1_N.vhd
--RISC-V Register system
--DatapathV1.vhd
-------------------------------------------------------------------------
--10/10/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;


entity DatapathV1 is
	clock	: in std_logic;
	reset	: in std_logic;

    RiscV_Inst : in std_logic_vector(31 downto 0);
end DatapathV1;

architecture structural of DatapathV1 is
	

    component ControlUnit is
        generic (ALU_OP_SIZE : positive);
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
            ALU_OP      : out std_logic_vector(3 downto 0));
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
        generic(N : integer); -- Generic of type integer for input/output data width. Default value is 32.
        port(	i_S          : in std_logic;
            i_D0         : in std_logic_vector(N-1 downto 0);
            i_D1         : in std_logic_vector(N-1 downto 0);
            o_O          : out std_logic_vector(N-1 downto 0));
    end component;

	component mem is
		generic( 	DATA_WIDTH : natural; 
					ADDR_WIDTH: natural);
		port(	clk		: in std_logic;
				addr 	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
				data 	: in std_logic_vector((DATA_WIDTH-1) downto 0);
				we		: in std_logic := '1';
				q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
	end component;
	
	component bitExtender16t32 is
		port(	i_sw	: in std_logic;
				i_16bit	: in std_logic_vector(15 downto 0);
				o_32bit	: out std_logic_vector(31 downto 0));
	end component;

    component ALU_V1 is
        port(
            i_A         : in std_logic_vector(31 downto 0);
            i_B         : in std_logic_vector(31 downto 0);
            i_Sub       : in std_logic;

            o_Result    : out std_logic_vector(31 downto 0);
            f_Zero      : out std_logic;
            f_Overflow  : out std_logic;
            f_Negative  : out std_logic);
        end component;

    component ALU_Control_v1 is
        generic (ALU_OP_SIZE : positive := 4);
        port(
            inst_type   : in std_logic_vector(ALU_OP_SIZE-1 downto 0);
            funct3      : in std_logic_vector(2 downto 0);
            funct7      : in std_logic_vector(6 downto 0);

            o_sub       : out std_logic);
    end component;

    --Control Unit Signals
    signal s_ALU_SRC    : std_logic;
    signal s_Mem_We     : std_logic;
    signal s_Jump       : std_logic;
    signal s_MemToReg   : std_logic;
    signal s_Reg_WE     : std_logic;
    signal s_Branch     : std_logic;
    signal s_ALU_OP     : std_logic_vector(3 downto 0);

    --Register Signals
    signal s_RS1Data    : std_logic_vector(31 downto 0);
    signal s_RS2Data    : std_logic_vector(31 downto 0);
    signal s_RegIn      : std_logic_vector(31 downto 0);

    --Memory Signals
    signal s_memOut     : std_logic_vector(31 downto 0);

    --ALU Control Signals
    signal s_AddSub     : std_logic;
    signal s_bVal       : std_logic_vector(31 downto 0);
    signal s_ALUres     : std_logic_vector(31 downto 0);
    
    --ALU Flags
    signal s_ZeroFlag   : std_logic;
    signal s_OvFlFlag   : std_logic;
    signal s_NegFlag    : std_logic;

    --Immediate Value
    signal s_immExt     : std_logic_vector(31 downto 0)



begin
    g_ContrUnit : ControlUnit
        generic map( ALU_OP_SIZE => 4)
        port map(
            opCode      => RiscV_Inst(6 downto 0),
            ALU_Src     => s_ALU_SRC,
            Jump        => s_Jump,
            MemToReg    => s_MemToReg,
            Reg_WE      => s_Reg_WE,
            s_Branch    => s_Branch,
            ALU_OP      => s_ALU_OP);
    
    g_Reg:  RegFile
        port map(  
            clock   => clock,
            reset   => reset,

            RS1Sel  => RiscV_Inst(19 downto 15),
            RS1     => s_RS1Data,

            RS2Sel  => RiscV_Inst(24 downto 20),
            RS2     => s_RS2Data,
            
            WrEn    => s_Reg_WE,
            RdSel   => RiscV_Inst(11 downto 7),
            Rd      => s_RegIn);

    dmem: mem
		generic map(	DATA_WIDTH	=> 32, 
						ADDR_WIDTH 	=> 10)
		port map(		CLK			=> clock,
						addr		=> s_ALUres(11 downto 2),
						data		=> s_bVal,
						we			=> s_Mem_We,
						q			=> s_memOut);
    
    g_ALU_Control: ALU_Control_v1
        generic map( ALU_OP_SIZE => 4)
        port map(
            inst_type   => s_ALU_OP,
            funct3      => RiscV_Inst(14 downto 12),
            funct7      => RiscV_Inst(31 downto 25),
            o_sub       => s_AddSub);

    g_ALU_Module: ALU_V1
        port map(
            i_A         => s_RS1Data,
            i_B         => s_RS2Data,
            i_Sub       => s_AddSub,
            o_Result    => s_ALUres,
            f_Zero      => s_ZeroFlag,
            f_Overflow  => s_OvFlFlag
            f_Negative  => s_NegFlag);

    g_BvalMux: mux2t1_N
        generic map(N => 32)
        port map(	
            i_S         => s_ALU_SRC,
            i_D0        => s_RS2Data,
            i_D1        => s_immExt,
            o_O         => s_bVal);

    g_OutMux: mux2t1_N
        generic map(N => 32)
        port map(	
            i_S         => s_MemToReg,
            i_D0        => s_ALUres,
            i_D1        => s_memOut,
            o_O         => s_RegIn);
end structural;