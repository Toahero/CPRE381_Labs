-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: Datapath1.vhd
--Testbed for the first datapath
--tb_dmem.vhd
-------------------------------------------------------------------------
--9/21/25 by JAG: Initially Created
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inst_mem is
    generic(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

    port(
        i_clk   : in std_logic;
        i_num   : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		o_inst  : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
end inst_mem;

architecture structural of inst_mem is

    component mem is
		generic(
            DATA_WIDTH : natural; 
			ADDR_WIDTH: natural
        );
        port(
            clk		: in std_logic;
			addr    : in std_logic_vector((ADDR_WIDTH-1) downto 0);
			data    : in std_logic_vector((DATA_WIDTH-1) downto 0);
			we	    : in std_logic := '1';
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
	end component;

    signal s_zero : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

    s_zero <= (others => '0');

    mem_module: mem
        generic map(
            DATA_WIDTH  => DATA_WIDTH,
            ADDR_WIDTH  => ADDR_WIDTH
        )
        port map(
            clk     => i_clk,
            addr    => i_num,
            data	=> s_zero,
            we      => '0',
            q       => o_inst
        );

end structural;
