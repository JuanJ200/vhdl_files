library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

-- ENTIDAD (Define la entrada numérica y la salida para los segmentos)

entity display7seg is -- Nombre del módulo decodificador
    Port(
        num : in integer range 0 to 9; -- Entrada del número entero a mostrar
        seg : out STD_LOGIC_VECTOR(6 downto 0) -- Salida de 7 bits para los segmentos (a-g)
    );
end display7seg; -- Fin de la entidad

-- ARQUITECTURA (Define la lógica de conversión a 7 segmentos)

architecture display7 of display7seg is
begin -- Inicio de la arquitectura

    -- PROCESO DE DECODIFICACIÓN (Convierte entero a patrón de bits)

    process(num) -- Se activa cada vez que el número de entrada cambia
    begin
        case num is -- Estructura de selección según el número
            when 0 => seg <= "1000000"; -- Patrón para mostrar el número 0
            when 1 => seg <= "1111001"; -- Patrón para mostrar el número 1
            when 2 => seg <= "0100100"; -- Patrón para mostrar el número 2
            when 3 => seg <= "0110000"; -- Patrón para mostrar el número 3
            when 4 => seg <= "0011001"; -- Patrón para mostrar el número 4
            when 5 => seg <= "0010010"; -- Patrón para mostrar el número 5
            when 6 => seg <= "0000010"; -- Patrón para mostrar el número 6
            when 7 => seg <= "1111000"; -- Patrón para mostrar el número 7
            when 8 => seg <= "0000000"; -- Patrón para mostrar el número 8
            when 9 => seg <= "0010000"; -- Patrón para mostrar el número 9
            when others => seg <= "1111111"; -- Apaga todos los segmentos en caso de error
        end case; -- Fin de la selección
    end process; -- Fin del proceso

end architecture display7; -- Fin de la arquitectura