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
begin
end rtl;