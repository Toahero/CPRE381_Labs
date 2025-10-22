-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: mux32t1.vhd, RegisterDecoder.vhd, nBitRegister.vhd, array32.vhd
--RISC-V Register system
--RegFile.vhd
-------------------------------------------------------------------------
--9/14/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use work.array32.all;

entity RegFile is
	port(	clock	: in std_logic;
		reset	: in std_logic;

		RS1Sel	: in std_logic_vector(4 downto 0);
		RS1	: out std_logic_vector(31 downto 0);

		RS2Sel	: in std_logic_vector(4 downto 0);
		RS2	: out std_logic_vector(31 downto 0);

		WrEn	: in std_logic;
		RdSel	: in std_logic_vector(4 downto 0);
		Rd	: in std_logic_vector(31 downto 0));
end RegFile;

architecture structural of RegFile is
	
	component nBitRegister is
		generic(Reg_Size: positive);
		port(	i_CLK	: in std_logic;
			i_reset	: in std_logic;
			i_WrEn	: in std_logic;
			i_write	: in std_logic_vector(Reg_Size-1 downto 0);
			o_read	: out std_logic_vector(Reg_Size-1 downto 0));
	end component;

	component mux32t1 is
		port(	i_d	: in array32bits32;
			i_sel	: in std_logic_vector(4 downto 0);
			o_out	: out std_logic_vector(31 downto 0));
	end component;

	component RegisterDecoder is
		port(	i_En	: in std_logic;
			i_Sel	: in std_logic_vector(4 downto 0);
			F_OUT	: out std_logic_vector(31 downto 0));
	end component;

signal s_WrEn	: std_logic_vector(31 downto 0);
signal s_ReadAr	: array32bits32;

begin
--Setting up the Registers
--Set up the 0 register
	zero_Reg: nBitRegister
		generic map(	Reg_Size	=> 32)
		port map(	i_CLK		=> clock,
				i_reset		=> '1',
				i_WrEn	=> s_WrEn(0),
				i_write	=> Rd,
				o_read	=> s_ReadAr(0));
--Set up the other 31 registers
	G_REGS: for i in 1 to 31 generate
		REG: nBitRegister
			generic map(	Reg_Size => 32)
			port map(	i_CLK	=> clock,
					i_reset	=> reset,
					i_WrEn	=> s_WrEn(i),
					i_write	=> Rd,
					o_read	=> s_ReadAr(i));
	end generate G_REGS;

--Setting up the Read Ports (RS1, RS2)
	g_RS1MUX: mux32t1
		port map(
			i_d	=> s_ReadAr,
			i_sel	=> RS1Sel,
			o_out	=> RS1);

	g_RS2MUX: mux32t1
		port map(
			i_d	=> s_ReadAr,
			i_sel	=> RS2Sel,
			o_out	=> RS2);

--Handling the Write (RD) port and capabilities

--WriteEnable

	g_RdDec: RegisterDecoder
		port map(	i_En	=> WrEn,
				i_Sel 	=> RdSel,
				F_OUT	=> s_WrEn);
end structural;
