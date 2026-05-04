library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic

-- PAQUETE DE CONFIGURACIÓN (Define constantes, tipos y componentes globales)
-- Este paquete centraliza los parámetros del sistema para facilitar cambios globales
package pkg_mem is

    -- CONSTANTES DE DISEÑO (Parámetros de tamaño de las memorias)
    constant DW : integer := 8;     -- DW (Data Width): Ancho de palabra de 8 bits para los datos
    constant AW : integer := 2;     -- AW (Address Width): Bus de dirección de 2 bits (permite 4 posiciones)
    constant DEPTH : integer := 4;  -- DEPTH: Número total de localidades de memoria (2^AW = 4)

    -- DEFINICIÓN DEL TIPO DE ESTADO
    -- Define los nombres de los estados que utilizará la Máquina de Estados (FSM)
    type fsm_t is (INI, READ_ROM, WRITE_RAM, READ_RAM, SHOW); -- Lista de estados del ciclo de control

    -- DECLARACIÓN DEL COMPONENTE ROM
    -- Memoria de solo lectura que contiene los datos predefinidos
    component rom_sync
        port(
            clk      : in  std_logic; -- Reloj de sincronización para la lectura
            addr     : in  std_logic_vector(AW-1 downto 0); -- Dirección de lectura (2 bits)
            data_out : out std_logic_vector(DW-1 downto 0)  -- Dato de 8 bits entregado por la ROM
        );
    end component;

    -- DECLARACIÓN DEL COMPONENTE RAM
    -- Memoria de lectura y escritura para almacenamiento temporal de datos
    component ram_sincrona
        port(
            clk      : in std_logic; -- Reloj de sincronización para lectura y escritura
            wr_en    : in std_logic; -- Habilitador de escritura (1 = guardar dato)
            rd_en    : in std_logic; -- Habilitador de lectura (1 = entregar dato)
            addr     : in std_logic_vector(AW-1 downto 0); -- Dirección de acceso a la memoria
            data_in  : in std_logic_vector(DW-1 downto 0); -- Dato que entra para ser guardado
            data_out : out std_logic_vector(DW-1 downto 0) -- Dato que sale tras ser leído
        );
    end component;

end package; -- Fin de la declaración del paquete
