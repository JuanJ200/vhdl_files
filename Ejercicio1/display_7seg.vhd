library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic

-- ENTIDAD (Define la entrada del número y la salida de los segmentos)

entity display_7seg is -- Nombre del módulo decodificador visual
    Port(
        numero : in integer range 0 to 9; -- Número entero a decodificar
        seg    : out STD_LOGIC_VECTOR(6 downto 0) -- Salida física a los segmentos
    );
end display_7seg; -- Fin de la entidad

-- ARQUITECTURA (Define qué segmentos encender para cada número)

architecture display7 of display_7seg is
begin -- Inicio de la arquitectura

    -- PROCESO DE CONVERSIÓN (Traducción a patrón de display)

    process(numero) -- Se ejecuta cada vez que el número de entrada cambia
    begin
        case numero is -- Selección según el valor numérico (0-9)
            when 0 => seg <= "1000000"; -- Dibuja el 0 (segmentos activos en bajo)
            when 1 => seg <= "1111001"; -- Dibuja el 1
            when 2 => seg <= "0100100"; -- Dibuja el 2
            when 3 => seg <= "0110000"; -- Dibuja el 3
            when 4 => seg <= "0011001"; -- Dibuja el 4
            when 5 => seg <= "0010010"; -- Dibuja el 5
            when 6 => seg <= "0000010"; -- Dibuja el 6
            when 7 => seg <= "1111000"; -- Dibuja el 7
            when 8 => seg <= "0000000"; -- Dibuja el 8
            when 9 => seg <= "0010000"; -- Dibuja el 9
            when others => seg <= "1111111"; -- Apaga el display si el valor es inválido
        end case; -- Fin de la selección
    end process; -- Fin del proceso

end architecture display7; -- Fin de la arquitectura