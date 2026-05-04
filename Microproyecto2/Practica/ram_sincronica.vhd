library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic
use IEEE.NUMERIC_STD.ALL; -- Permite realizar conversiones de vectores a enteros para indexar la memoria
use work.pkg_mem.all; -- Importa las constantes DW, AW y DEPTH definidas en el paquete

-- ENTIDAD DE LA RAM SÍNCRONA (Define la interfaz de lectura y escritura de la memoria)
-- Este módulo permite almacenar y recuperar datos de 8 bits de forma volátil
entity ram_sincrona is
    port(
        clk      : in std_logic; -- Reloj para sincronizar todas las operaciones de la memoria
        wr_en    : in std_logic; -- Habilitador de escritura (1 = guardar dato en la dirección 'addr')
        rd_en    : in std_logic; -- Habilitador de lectura (1 = extraer dato de la dirección 'addr')
        addr     : in std_logic_vector(AW-1 downto 0); -- Dirección de memoria para acceder (2 bits)
        data_in  : in std_logic_vector(DW-1 downto 0); -- Dato de 8 bits que se desea guardar
        data_out : out std_logic_vector(DW-1 downto 0) -- Dato de 8 bits que se recupera de la memoria
    );
end entity;

-- ARQUITECTURA (Define la estructura interna y el comportamiento de almacenamiento)
architecture rtl of ram_sincrona is

    -- DEFINICIÓN DEL TIPO DE MATRIZ
    -- Se crea un tipo "array" que representa la estructura física de la RAM (4 localidades de 8 bits)
    type ram_array is array (0 to DEPTH-1) of std_logic_vector(DW-1 downto 0);
    
    -- INSTANCIACIÓN DE LA MEMORIA
    -- Se crea la señal RAM y se inicializan todas sus posiciones en cero por defecto
    signal RAM : ram_array := (others => (others => '0'));

begin

    -- PROCESO DE CONTROL DE LA RAM
    -- Gestiona las operaciones de lectura y escritura de forma síncrona al reloj
    process(clk)
    begin
        -- Las operaciones solo ocurren en el flanco de subida del reloj
        if rising_edge(clk) then

            -- OPERACIÓN DE ESCRITURA
            -- Si wr_en está activo, el dato de entrada se guarda en la posición indicada por 'addr'
            if wr_en = '1' then
                RAM(to_integer(unsigned(addr))) <= data_in; -- Conversión de dirección a entero para indexar
            end if;

            -- OPERACIÓN DE LECTURA
            -- Si rd_en está activo, el dato almacenado en 'addr' se envía a la salida 'data_out'
            if rd_en = '1' then
                data_out <= RAM(to_integer(unsigned(addr))); -- Lectura síncrona del dato almacenado
            end if;

        end if;
    end process; -- Fin del proceso de control

end architecture; -- Fin de la lógica rtl
