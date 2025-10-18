library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library std;
use std.textio.all;             -- For basic I/O

entity tb_Datapath2 is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);  
end tb_Datapath2;

architecture mixed of tb_Datapath2 is

    -- Component Under Test (C.U.T)
    component Datapath2 is
        port(
            clock   : in std_logic; 
            reset   : in std_logic; --Active High Reset

            memIn   : in std_logic;
            ALUSrc  : in std_logic;
            --IM_Sw   : in std_logic;
            
            Imm     : in std_logic_vector(15 downto 0);
            
            AddSub  : in std_logic;
            ovflw   : out std_logic;

            Reg_Wr  : in std_logic;
            Rd      : in std_logic_vector(4 downto 0);
            RS1     : in std_logic_vector(4 downto 0);
            RS2     : in std_logic_vector(4 downto 0);

            Mem_Wr  : in std_logic);
    end component;

    -- Signals to connect to Datapath2
    signal CLK   : std_logic := '0';
    signal reset   : std_logic := '1';
    signal ins_cnt  : std_logic_vector(15 downto 0) := x"0000";

    signal ALUSrc  : std_logic := '0';
    --signal IM_Sw   : std_logic := '0';
    signal Imm     : std_logic_vector(15 downto 0) := x"0000";
    signal AddSub  : std_logic := '0';
    signal memIn   : std_logic := '0';
    signal ovflw   : std_logic;

    signal Reg_Wr  : std_logic := '0';
    signal Rd      : std_logic_vector(4 downto 0) := "00000";
    signal RS1     : std_logic_vector(4 downto 0) := "00000";
    signal RS2     : std_logic_vector(4 downto 0) := "00000";

    signal Mem_Wr  : std_logic := '0';

begin

    -- Instantiate the Datapath2
    DATAFILE: Datapath2
        port map(
            clock   => CLK,
            reset   => reset,

            memIn   => memIn,
            ALUSrc  => ALUSrc,
            --IM_Sw   => IM_Sw,
            Imm     => Imm,
            AddSub  => AddSub,
            ovflw   => ovflw,

            Reg_Wr  => Reg_Wr,
            Rd      => Rd,
            RS1     => RS1,
            RS2     => RS2,

            Mem_Wr  => Mem_Wr
        );

    -- Clock generation
P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

-- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;

P_TEST_InstructionS: process
begin
	wait for gCLK_HPER*3; --Wait for reset to finish
	wait for gCLK_HPER/2; --Change inputs on clk midpoints

--Instruction 0: addi 25, zero , 0
ins_cnt <= std_logic_vector(to_unsigned(0, 16));
AddSub  <= '0';
ALUSrc  <= '1'; --Source from immediate
Rd     <= std_logic_vector(to_unsigned(25, 5));
RS1     <= std_logic_vector(to_unsigned(0, 5));
Imm     <= std_logic_vector(to_signed(0, 16)); --Set immediate to 0
--Enable for one clock cycle
Reg_Wr		<= '1';
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;

--Instruction 1: addi 26, zero , 256
ins_cnt <= std_logic_vector(to_unsigned(1, 16));
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '1'; --Source from immediate
Rd     <= std_logic_vector(to_unsigned(26, 5));
RS1     <= std_logic_vector(to_unsigned(0, 5));
Imm     <= std_logic_vector(to_signed(256, 16)); --Set immediate to 0
--Enable for one clock cycle
Reg_Wr		<= '1';
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;

--Instruction 2: lw 1, 0(25)
ins_cnt <= std_logic_vector(to_unsigned(2, 16));
--Start by loading the address value into sum
AddSub  <= '0';
ALUSrc  <= '1'; --Source from immediate
RS1     <= std_logic_vector(to_unsigned(25, 5));--Port 25
Imm     <= std_logic_vector(to_signed(0, 16)); --Set immediate to 0
--Next, load that address from memory
Rd      <= std_logic_vector(to_unsigned(2, 5));
memIn   <= '1';
Reg_Wr		<= '1'; --Write the value into register 1
wait for gCLK_HPER;
Reg_Wr		<= '0';
memIn   <= '0';
wait for gCLK_HPER;


--Instruction 3: lw 1, 4(25)
ins_cnt <= std_logic_vector(to_unsigned(2, 16));
--Start by loading the address value into sum
AddSub  <= '0';
ALUSrc  <= '1'; --Source from immediate
RS1     <= std_logic_vector(to_unsigned(25, 5));--Port 25
Imm     <= std_logic_vector(to_signed(4, 16)); --Set immediate to 4
--Next, load that address from memory
Rd      <= std_logic_vector(to_unsigned(1, 5));
memIn   <= '1';
Reg_Wr		<= '1'; --Write the value into register 1
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 4: add 1, 1, 2
ins_cnt <= std_logic_vector(to_unsigned(4, 16));
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '0'; --Source from Register
Rd     <= std_logic_vector(to_unsigned(1, 5));
RS1     <= std_logic_vector(to_unsigned(1, 5));
RS2     <= std_logic_vector(to_unsigned(2, 5));
Reg_Wr		<= '1';--Enable for one clock cycle
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;

--Instruction 5: sw 1, 0(26)
ins_cnt <= std_logic_vector(to_unsigned(5, 16)); --Program Counter to 5
memIn   <= '0';
ALUSrc  <= '1'; --Source from Immediate
RS1     <= std_logic_vector(to_unsigned(26, 5)); --Write to the memory address in R26 plus IMM
Imm     <= std_logic_vector(to_signed(0, 16)); --Set immediate to 0
RS2     <=std_logic_vector(to_unsigned(1, 5)); --Write the value stored in R1
Mem_Wr		<= '1';
wait for gCLK_HPER;
mem_wr    <= '0';
wait for gCLK_HPER;

--Instruction 6: lw 2, 8(25)
ins_cnt <= std_logic_vector(to_unsigned(2, 16));
--Start by loading the address value into sum
AddSub  <= '0';
ALUSrc  <= '1'; --Source from immediate
RS1     <= std_logic_vector(to_unsigned(25, 5));--Port 25
Imm     <= std_logic_vector(to_signed(8, 16)); --Set immediate to 8
--Next, load that address from memory
Rd      <= std_logic_vector(to_unsigned(2, 5));--Value will be written into R2
memIn   <= '1';
Reg_Wr		<= '1'; --Write the value into register 2
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 7: add 1, 1, 2
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '0'; --Source from Register
Rd     <= std_logic_vector(to_unsigned(1, 5));
RS1     <= std_logic_vector(to_unsigned(1, 5));
RS2     <= std_logic_vector(to_unsigned(2, 5));
Reg_Wr		<= '1';--Enable for one clock cycle
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 8: sw 1, 4(26)
memIn   <= '0';
ALUSrc  <= '1'; --Source from Immediate
RS1     <= std_logic_vector(to_unsigned(26, 5)); --Write to the memory address in R26 plus IMM
Imm     <= std_logic_vector(to_signed(4, 16)); --Set immediate to 4
RS2     <=std_logic_vector(to_unsigned(1, 5)); --Write the value stored in R1
Mem_Wr		<= '1';
wait for gCLK_HPER;
mem_wr    <= '0';
wait for gCLK_HPER;


--Instruction 9: lw 2, 12(25)
AddSub  <= '0';--Start by loading the address value into sum
ALUSrc  <= '1'; --Source from immediate
RS1     <= std_logic_vector(to_unsigned(25, 5));--Port 25
Imm     <= std_logic_vector(to_signed(12, 16)); --Set immediate to 12
--Next, load that address from memory
Rd      <= std_logic_vector(to_unsigned(2, 5));--Value will be written into R2
memIn   <= '1';
Reg_Wr		<= '1'; --Write the value into register 2
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 10: add 1, 1, 2
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '0'; --Source from Register
Rd     <= std_logic_vector(to_unsigned(1, 5));
RS1     <= std_logic_vector(to_unsigned(1, 5));
RS2     <= std_logic_vector(to_unsigned(2, 5));
Reg_Wr		<= '1';--Enable for one clock cycle
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 11: sw 1, 8(26)
memIn   <= '0';
ALUSrc  <= '1'; --Source from Immediate
RS1     <= std_logic_vector(to_unsigned(26, 5)); --Write to the memory address in R26 plus IMM
Imm     <= std_logic_vector(to_signed(8, 16)); --Set immediate to 8
RS2     <=std_logic_vector(to_unsigned(1, 5)); --Write the value stored in R1
Mem_Wr		<= '1';
wait for gCLK_HPER;
mem_wr    <= '0';
wait for gCLK_HPER;


--Instruction 12: lw 2, 16(25)
AddSub  <= '0';--Start by loading the address value into sum
ALUSrc  <= '1'; --Source from immediate
RS1     <= std_logic_vector(to_unsigned(25, 5));--Port 25
Imm     <= std_logic_vector(to_signed(16, 16)); --Set immediate to 16
--Next, load that address from memory
Rd      <= std_logic_vector(to_unsigned(2, 5));--Value will be written into R2
memIn   <= '1';
Reg_Wr		<= '1'; --Write the value into register 2
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 13: add 1, 1, 2
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '0'; --Source from Register
Rd     <= std_logic_vector(to_unsigned(1, 5));
RS1     <= std_logic_vector(to_unsigned(1, 5));
RS2     <= std_logic_vector(to_unsigned(2, 5));
Reg_Wr		<= '1';--Enable for one clock cycle
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 14: sw 1, 12(26)
memIn   <= '0';
ALUSrc  <= '1'; --Source from Immediate
RS1     <= std_logic_vector(to_unsigned(26, 5)); --Write to the memory address in R26 plus IMM
Imm     <= std_logic_vector(to_signed(12, 16)); --Set immediate to 12
RS2     <=std_logic_vector(to_unsigned(1, 5)); --Write the value stored in R1
Mem_Wr		<= '1';
wait for gCLK_HPER;
mem_wr    <= '0';
wait for gCLK_HPER;


--Instruction 15: lw 2, 20(25)
AddSub  <= '0';--Start by loading the address value into sum
ALUSrc  <= '1'; --Source from immediate
RS1     <= std_logic_vector(to_unsigned(25, 5));--Port 25
Imm     <= std_logic_vector(to_signed(20, 16)); --Set immediate to 20
--Next, load that address from memory
Rd      <= std_logic_vector(to_unsigned(2, 5));--Value will be written into R2
memIn   <= '1';
Reg_Wr		<= '1'; --Write the value into register 2
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 16: add 1, 1, 2
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '0'; --Source from Register
Rd     <= std_logic_vector(to_unsigned(1, 5));
RS1     <= std_logic_vector(to_unsigned(1, 5));
RS2     <= std_logic_vector(to_unsigned(2, 5));
Reg_Wr		<= '1';--Enable for one clock cycle
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 17: sw 1, 16(26)
memIn   <= '0';
ALUSrc  <= '1'; --Source from Immediate
RS1     <= std_logic_vector(to_unsigned(26, 5)); --Write to the memory address in R26 plus IMM
Imm     <= std_logic_vector(to_signed(12, 16)); --Set immediate to 16
RS2     <=std_logic_vector(to_unsigned(1, 5)); --Write the value stored in R1
Mem_Wr		<= '1';
wait for gCLK_HPER;
mem_wr    <= '0';
wait for gCLK_HPER;


--Instruction 18: lw 2, 24(25)
AddSub  <= '0';--Start by loading the address value into sum
ALUSrc  <= '1'; --Source from immediate
RS1     <= std_logic_vector(to_unsigned(25, 5));--Port 25
Imm     <= std_logic_vector(to_signed(24, 16)); --Set immediate to 24
--Next, load that address from memory
Rd      <= std_logic_vector(to_unsigned(2, 5));--Value will be written into R2
memIn   <= '1';
Reg_Wr		<= '1'; --Write the value into register 2
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 19: add 1, 1, 2
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '0'; --Source from Register
Rd     <= std_logic_vector(to_unsigned(1, 5));
RS1     <= std_logic_vector(to_unsigned(1, 5));
RS2     <= std_logic_vector(to_unsigned(2, 5));
Reg_Wr		<= '1';--Enable for one clock cycle
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 20: addi 27, zero, 512
memIn   <= '0';
AddSub  <= '0';
ALUSrc  <= '1'; --Source from immediate
Rd     <= std_logic_vector(to_unsigned(27, 5));
RS1     <= std_logic_vector(to_unsigned(0, 5));
Imm     <= std_logic_vector(to_signed(512, 16)); --Set immediate to 0
--Enable for one clock cycle
Reg_Wr		<= '1';
wait for gCLK_HPER;
Reg_Wr		<= '0';
wait for gCLK_HPER;


--Instruction 21: sw 1, -4(27)
memIn   <= '0';
ALUSrc  <= '1'; --Source from Immediate
RS1     <= std_logic_vector(to_unsigned(27, 5)); --Write to the memory address in R26 plus IMM
Imm     <= std_logic_vector(to_signed(-4, 16)); --Set immediate to 16
RS2     <=std_logic_vector(to_unsigned(1, 5)); --Write the value stored in R1
Mem_Wr		<= '1';
wait for gCLK_HPER;
mem_wr    <= '0';
wait for gCLK_HPER;

--Instruction 22: sw 1, -4(27)
memIn   <= '0';
ALUSrc  <= '1'; --Source from Immediate
RS1     <= std_logic_vector(to_unsigned(27, 5)); --Write to the memory address in R26 plus IMM
Imm     <= std_logic_vector(to_signed(-4, 16)); --Set immediate to 16
RS2     <=std_logic_vector(to_unsigned(1, 5)); --Write the value stored in R1
Mem_Wr		<= '1';
wait for gCLK_HPER;
mem_wr    <= '0';
wait for gCLK_HPER;

wait;
end process;
end mixed;