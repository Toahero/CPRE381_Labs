
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_IsZero is
  generic(
    clock : time := 10 ns;
    WIDTH : integer := 32
  );
end tb_IsZero;

architecture behaviour of tb_IsZero is

    component IsZero is
        generic(
            WIDTH : integer := 32
        );
        port(
            i_Value : std_logic_vector(WIDTH - 1 downto 0);
            o_IsZero : std_logic := '0'
        );
    end component;

    signal s_Clock : std_logic;

    signal s_iInput : std_logic_vector(WIDTH - 1 downto 0);
    signal s_oIsZero : std_logic := '0';

begin

    testbench : IsZero
        generic map(
            WIDTH => WIDTH
        )
        port map(
            i_Value => s_iInput,
            o_IsZero => s_oIsZero
        );

    p_clock : process
    begin
        wait for clock;
        s_Clock <= '1';

        wait for clock;
        s_Clock <= '0';
    end process ; -- clock

    tests : process
    begin

        wait for (clock / 2);


        wait;        
    end process ; -- tests


end behaviour ; -- behaviour
