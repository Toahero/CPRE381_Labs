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

entity LogicModule is
    generic(
        DATA_WIDTH : integer := 32 -- Generic of type integer for input/output data width. Default value is 32.
    );
    port(
        i_aVal       : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_bVal       : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_OppSel     : in std_logic_vector(2 downto 0);
        o_Out        : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end LogicModule;

architecture mixed of LogicModule is

    component mux2t1_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_S          : in std_logic;
            i_D0         : in std_logic_vector(N-1 downto 0);
            i_D1         : in std_logic_vector(N-1 downto 0);
            o_O          : out std_logic_vector(N-1 downto 0));
    end component;

signal s_AND    : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_OR     : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_XOR    : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_AndOr    : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
    s_AND   <= i_aVal AND i_bVal;
    s_OR    <= i_aVal OR i_bVal;
    s_XOR    <= i_aVal XOR i_bVal;

    MUX1: mux2t1_N
        generic map(N => DATA_WIDTH)
        port map(   i_S     => i_OppSel(0),
                    i_D0    => s_AND,
                    i_D1    => s_OR,
                    o_O     => s_AndOr);

    MUX2: mux2t1_N
        generic map(N => DATA_WIDTH)
        port map(   i_S     => i_OppSel(1),
                    i_D0    => s_AndOr,
                    i_D1    => s_XOR,
                    o_O     => o_Out);
end mixed;