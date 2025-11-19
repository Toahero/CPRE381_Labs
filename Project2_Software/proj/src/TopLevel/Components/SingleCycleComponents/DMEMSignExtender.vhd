library IEEE;
use IEEE.std_logic_1164.all;

entity DMEMSignExtender is
    port(
        i_Data          : in std_logic_vector(31 downto 0);
        i_Funct3        : in std_logic_vector(2 downto 0);

        o_SignExtendedDMEM : out std_logic_vector(31 downto 0)       
    );
end DMEMSignExtender;

architecture behaviour of DMEMSignExtender is

    signal s_ByteExtended : std_logic_vector(31 downto 8 );
    signal s_HalfExtended : std_logic_vector(31 downto 16);

    signal s_extbit : std_logic;

begin

    with i_Funct3 select
        s_extbit <= i_Data(7)   when "000",
                    i_Data(15)  when "001",
                    i_Data(31)  when "010",
                    '0'         when "100",
                    '0'         when "101",
                    '0'         when others;
    
    s_ByteExtended  <= (others => s_extbit);
    s_HalfExtended  <= (others => s_extbit);

    with i_Funct3 select
        o_SignExtendedDMEM  <=  s_ByteExtended & i_Data(7  downto 0) when "000" | "100",
                                s_HalfExtended & i_Data(15 downto 0) when "001" | "101",
                                i_Data when others;

end behaviour;
