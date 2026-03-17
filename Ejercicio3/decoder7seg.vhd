library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic

-- ENTIDAD (Define la entrada numérica y la salida para los segmentos)

entity decoder7seg is -- Nombre del módulo decodificador
    Port(
        num : in integer range 0 to 9; -- Entrada del número entero a mostrar
        seg : out STD_LOGIC_VECTOR(6 downto 0) -- Salida de 7 bits para los segmentos
    );
end decoder7seg; -- Fin de la entidad

-- ARQUITECTURA (Define el funcionamiento de la conversión)

architecture dec7 of decoder7seg is
begin -- Inicio de la arquitectura

    -- PROCESO DE DECODIFICACIÓN (Selecciona el patrón según el número)

    process(num) -- Se activa cuando cambia el valor de num
    begin
        case num is -- Estructura de selección de caso
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
            when others => seg <= "1111111"; -- Patrón por defecto (apagado)
        end case; -- Fin de la selección
    end process; -- Fin del proceso

end architecture dec7; -- Fin de la arquitectura