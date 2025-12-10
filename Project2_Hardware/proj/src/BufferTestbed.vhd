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

architecture behavior of tb_BufferTestbed is
    
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

    signal CLK : std_logic;

begin

    

    P_CLK: process
    begin
        CLK <= '1';
        wait for gCLK_HPER;
        CLK <= '0';
        wait for gCLK_HPER;
    end process;

    P_TEST_CASES: process
    begin
        -- Base State

        wait;
    end process P_TEST_CASES;

end architecture behavior;
