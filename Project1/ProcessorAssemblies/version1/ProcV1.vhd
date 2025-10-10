-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: RegFile.vhd, addSun_n.vhd, mux2t1_N.vhd
--RISC-V Register system
--Proc1.vhd
-------------------------------------------------------------------------
--10/10/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;


entity Proc1 is
	clock	: in std_logic;
	reset	: in std_logic;
end Proc1;

architecture structural of Proc1 is
	

    component ControlUnit is
    port(
        opCode      : in std_logic_vector(6 downto 0); --The Opcode is 7 bits long
        funt7_imm   : in std_logic_vector(6 downto 0); --Funct7 is 3 bits long

        --These have been assigned
        ALU_Src      : out std_logic; --Source an extended immediate
        Mem_We      : out std_logic; --Enable writing to memory
        Jump        : out std_logic; --Execute a jump
        MemToReg    : out std_logic; --Write a memory value into a register
        Reg_WE      : out std_logic;
        Branch      : out std_logic;
        
        --These have not been assigned   
        ALU_OP      : out std_logic_vector(2 downto 0));
    end component;

   component inst_mem is
        generic(
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );
    
        port(
            i_clk   : in std_logic;
            i_num   : in std_logic_vector((ADDR_WIDTH-1) downto 0);
            o_inst  : out std_logic_vector((DATA_WIDTH -1) downto 0)
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

   component addSub_n is
	generic(Comp_Width : integer); -- Generic of type integer for input/output data width.
	port(	nAdd_Sub	: in std_logic;
		i_A		: in std_logic_vector(Comp_Width-1 downto 0);
		i_B		: in std_logic_vector(Comp_Width-1 downto 0);
		o_overflow	: out std_logic;
		o_Sum		: out std_logic_vector(Comp_Width-1 downto 0));
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

begin
	
end structural;