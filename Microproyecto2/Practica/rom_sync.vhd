library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_sync is
    port(
        clk      : in  std_logic;
        addr     : in  std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end;

architecture rtl of rom_sync is
    type rom_array is array (0 to 3) of std_logic_vector(7 downto 0);
    constant ROM : rom_array := ("00010010", "11001010", "00000111", "10101111");
begin
    data_out <= ROM(0); -- Línea temporal para probar pines
end rtl;
