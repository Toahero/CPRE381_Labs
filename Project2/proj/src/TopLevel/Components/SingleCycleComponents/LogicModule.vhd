-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: mux2t1N
--Description: N bit and gate

--
-------------------------------------------------------------------------
--10/18/25 by JAG: Initially Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- 00 => AND
-- 01 => OR
-- 10 => XOR
-- 11 => XOR

entity LogicModule is
  generic(DATA_WIDTH : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(
       i_aVal       : in std_logic_vector(DATA_WIDTH-1 downto 0);
       i_bVal       : in std_logic_vector(DATA_WIDTH-1 downto 0);
       i_OppSel     : in std_logic_vector(1 downto 0);
       o_Out        : out std_logic_vector(DATA_WIDTH-1 downto 0));

end LogicModule;

architecture mixed of LogicModule is
    
    signal s_AND    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_OR     : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_XOR    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_AndOr    : std_logic_vector(DATA_WIDTH-1 downto 0);
    
begin
    s_AND   <= i_aVal AND i_bVal;
    s_OR    <= i_aVal OR  i_bVal;
    s_XOR   <= i_aVal XOR i_bVal;

    o_Out <=    s_AND   when i_OppSel = b"00" else
                s_OR    when i_OppSel = b"01" else
                s_XOR   when i_OppSel = b"10" else
                s_XOR   when i_OppSel = b"11" else
                (others => '0');

end mixed;