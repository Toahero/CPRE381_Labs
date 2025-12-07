library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISCV_types.t_IFID;
use work.RISCV_types.t_IDEX;
use work.RISCV_types.t_EXMEM;
use work.RISCV_types.t_MEMWB;

entity tb_BufferTestbed is
    generic(
        gCLK_HPER   : time := 10 ns
    );
end tb_BufferTestbed;

architecture mixed of tb_BufferTestbed is
    
    component Buffer_IFID is
        port(
            i_Clock                 : in  std_logic;
            i_Reset                 : in  std_logic;
            i_WriteEnable           : in  std_logic;
            i_NOP                   : in  std_logic;

            i_Next                  : in  t_IFID;
            o_Current               : out t_IFID
        );
    end component;

    component Buffer_IDEX is
        port(
            i_Clock                 : in  std_logic;
            i_Reset                 : in  std_logic;
            i_WriteEnable           : in  std_logic;

            i_Next                  : in  t_IDEX;
            o_Current               : out t_IDEX
        );
    end component;

    component Buffer_EXMEM is
        port(
            i_Clock             : in  std_logic;
            i_Reset             : in  std_logic;
            i_WriteEnable       : in  std_logic;
            i_Next              : in  t_EXMEM;
            o_Current           : out t_EXMEM
        );
    end component;

    component Buffer_MEMWB is
        port(
            i_Clock                 : in  std_logic;
            i_Reset                 : in  std_logic;
            i_WriteEnable           : in  std_logic;

            i_Next                  : in  t_MEMWB;
            o_Current               : out t_MEMWB
        );
    end component;

    signal CLK  : std_logic;

    --Signals for inserting NOPs into IFID
    signal s_InsNOP   : std_logic;

    --Signals for Write Enable
    signal s_IfId_En  : std_logic;
    signal s_IdEx_En  : std_logic;
    signal s_ExMem_En : std_logic;
    signal s_MemWb_En : std_logic;

    --Signals for buffer reset (flush)
    signal s_IfId_R   : std_logic;
    signal s_IdEx_R   : std_logic;
    signal s_ExMem_R  : std_logic;
    signal s_MemWb_R  : std_logic;

    --Signals for 