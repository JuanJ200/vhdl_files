library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seg7 is
    port(
        digit : in std_logic_vector(3 downto 0);
        seg   : out std_logic_vector(6 downto 0)
    );
end;

architecture rtl of seg7 is
begin
end rtl;