-------------------------------------------------------------------------
-- Author: Braedon Giblin
-- Date: 2022.02.12
-- Files: RISCV_types.vhd
-------------------------------------------------------------------------
-- Description: This file contains a skeleton for some types that 381 students
-- may want to use. This file is guarenteed to compile first, so if any types,
-- constants, functions, etc., etc., are wanted, students should declare them
-- here.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package RISCV_types is

  type array32bits32 is array (0 to 31) of std_logic_vector(31 downto 0);

  type t_IFID is record
    Instruction         : std_logic_vector(31 downto 0);
    ProgramCounter      : std_logic_vector(31 downto 0);
  end record t_IFID;

  type t_IDEX is record
    Mem_We              : std_logic;
    MemToReg            : std_logic;
    Reg_WE              : std_logic;
    HaltProg            : std_logic;
    ALU_Operand1        : std_logic_vector(31 downto 0);
    ALU_Operand2        : std_logic_vector(31 downto 0);
    RS2                 : std_logic_vector(31 downto 0);
    Instruction         : std_logic_vector(31 downto 0);
    ProgramCounter      : std_logic_vector(31 downto 0);
  end record t_IDEX;

  type t_EXMEM is record
    Mem_We              : std_logic;
    MemToReg            : std_logic;
    Reg_WE              : std_logic;
    HaltProg            : std_logic;
    ALU_Output          : std_logic_vector(31 downto 0);
    RS2                 : std_logic_vector(31 downto 0);
    Instruction         : std_logic_vector(31 downto 0);
  end record t_EXMEM;

  type t_MEMWB is record
    MemToReg            : std_logic;
    Reg_WE              : std_logic;
    HaltProg            : std_logic;
    DMem_Output         : std_logic_vector(31 downto 0);
    ALU_Output          : std_logic_vector(31 downto 0);
    Instruction         : std_logic_vector(31 downto 0);
  end record t_MEMWB;

end package RISCV_types;

package body RISCV_types is
end package body RISCV_types;
