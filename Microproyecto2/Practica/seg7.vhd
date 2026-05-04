library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic

-- ENTIDAD DEL DECODIFICADOR (Define la interfaz de conversión binario a 7 segmentos)
-- Este módulo transforma un número binario de 4 bits en el patrón físico para el display
entity seg7 is
    port(
        bin : in  std_logic_vector(3 downto 0); -- Entrada: Valor binario (0 a 15) a representar
        seg : out std_logic_vector(6 downto 0)  -- Salida: Control de los 7 segmentos (a, b, c, d, e, f, g)
    );
end entity;

-- ARQUITECTURA (Define la tabla de verdad para la visualización)
architecture rtl of seg7 is
begin
    -- PROCESO COMBINACIONAL
    -- Se activa instantáneamente cada vez que cambia el valor de la entrada 'bin'
    process(bin)
    begin
        case bin is
            -- MAPEO DE SEGMENTOS (Lógica de Ánodo Común: '0' enciende, '1' apaga)
            -- El orden de los bits en la salida es: g f e d c b a
            when "0000" => seg <= "1000000"; -- Representa el número 0
            when "0001" => seg <= "1111001"; -- Representa el número 1
            when "0010" => seg <= "0100100"; -- Representa el número 2
            when "0011" => seg <= "0110000"; -- Representa el número 3
            when "0100" => seg <= "0011001"; -- Representa el número 4
            when "0101" => seg <= "0010010"; -- Representa el número 5
            when "0110" => seg <= "0000010"; -- Representa el número 6
            when "0111" => seg <= "1111000"; -- Representa el número 7
            when "1000" => seg <= "0000000"; -- Representa el número 8
            when "1001" => seg <= "0010000"; -- Representa el número 9
            
            -- CASO POR DEFECTO
            -- Para cualquier otro valor (10 a 15), se apagan todos los segmentos
            when others => seg <= "1111111"; -- Display apagado
        end case;
    end process; -- Fin del proceso de decodificación
end architecture; -- Fin de la lógica rtl
