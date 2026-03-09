library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Convierte un número del 0 al 9 en las señales
-- Las necesarias para el display 7 segmentos


entity display_7seg is
Port(
    numero : in integer range 0 to 9;          -- número a mostrar
    seg : out STD_LOGIC_VECTOR(6 downto 0)     -- salidas a los segmentos
);
end display_7seg;

architecture display7 of display_7seg is
begin

-- proceso que revisa el número recibido
process(numero)
begin

case numero is

-- cada valor corresponde a los segmentos del display

when 0 => seg <= "1000000";
when 1 => seg <= "1111001";
when 2 => seg <= "0100100";
when 3 => seg <= "0110000";
when 4 => seg <= "0011001";
when 5 => seg <= "0010010";
when 6 => seg <= "0000010";
when 7 => seg <= "1111000";
when 8 => seg <= "0000000";
when 9 => seg <= "0010000";

-- si llega otro número, apaga el display
when others => seg <= "1111111";

end case;

end process;

end architecture display7;