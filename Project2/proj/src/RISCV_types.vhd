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
    Jump                : std_logic;
    MemToReg            : std_logic;
    BranchEnable        : std_logic;
    ALU_Source          : std_logic;
    MemoryWriteEnable   : std_logic;
    RegisterWriteEnable : std_logic;
    Halt                : std_logic;
    Instruction         : std_logic_vector(31 downto 0);
  end record t_IFID;

  type t_IDEX is record
    Jump                : std_logic;
    MemToReg            : std_logic;
    BranchEnable        : std_logic;
    ALU_Source          : std_logic;
    MemoryWriteEnable   : std_logic;
    Halt                : std_logic;
    Instruction         : std_logic_vector(31 downto 0);
    RS1_Value           : std_logic_vector(31 downto 0);
    RS2_Value           : std_logic_vector(31 downto 0);
    Immediate           : std_logic_vector(31 downto 0);
  end record t_IDEX;

  

  type t_MEMWB is record
    MemToReg            : std_logic;
    Halt                : std_logic;
    ALUResult           : std_logic_vector(31 downto 0);
    MemoryOut           : std_logic_vector(31 downto 0);
    RegisterDataAddress : std_logic_vector( 4 downto 0);
  end record t_MEMWB;

end package RISCV_types;

package body RISCV_types is  
end package body RISCV_types;
