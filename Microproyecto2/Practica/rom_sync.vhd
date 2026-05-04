library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic
use IEEE.NUMERIC_STD.ALL; -- Permite realizar conversiones de vectores a enteros
use work.pkg_mem.all; -- Importa las constantes DW, AW y DEPTH definidas en el paquete

-- ENTIDAD DE LA ROM SÍNCRONA (Define la interfaz de lectura de la memoria)
-- Este módulo entrega un dato predefinido en cada flanco de reloj según la dirección de entrada
entity rom_sync is
    port(
        clk      : in  std_logic; -- Reloj para sincronizar la lectura de los datos
        addr     : in  std_logic_vector(AW-1 downto 0); -- Dirección de memoria a consultar (2 bits)
        data_out : out std_logic_vector(DW-1 downto 0)  -- Dato de 8 bits que sale de la ROM
    );
end entity;

-- ARQUITECTURA (Define el contenido y el comportamiento de la memoria)
architecture rtl of rom_sync is

    -- DEFINICIÓN DEL TIPO DE MATRIZ
    -- Se crea un tipo "array" que representa la estructura física de la memoria (4 filas de 8 bits)
    type rom_array is array (0 to DEPTH-1) of std_logic_vector(DW-1 downto 0);

    -- CONTENIDO DE LA MEMORIA (Datos constantes)
    -- Se definen los valores fijos que estarán grabados en la ROM
    constant ROM : rom_array := (
        "00010010", -- Dirección 0: Valor decimal 18
        "11001010", -- Dirección 1: Valor decimal 202
        "00000111", -- Dirección 2: Valor decimal 7
        "10101111"  -- Dirección 3: Valor decimal 175
    );

begin

    -- PROCESO DE LECTURA SÍNCRONA
    -- La memoria solo entrega el dato cuando detecta un flanco de subida en el reloj
    process(clk)
    begin
        if rising_edge(clk) then -- Condición de flanco de subida (sincronismo)
            -- Se convierte la dirección de vector a entero para indexar la matriz y se asigna a la salida
            data_out <= ROM(to_integer(unsigned(addr))); 
        end if;
    end process; -- Fin del proceso de lectura

end architecture; -- Fin de la lógica rtl
