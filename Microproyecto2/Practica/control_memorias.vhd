library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic
use IEEE.NUMERIC_STD.ALL; -- Permite operaciones aritméticas y conversiones numéricas
use work.pkg_mem.all; -- Importa el paquete con constantes (AW, DW) y componentes del proyecto

-- ENTIDAD TOP LEVEL (Define las señales físicas que conectan con los pines de la FPGA)
-- Módulo principal que integra el divisor, las memorias y la lógica de visualización
entity control_memorias is
    port(
        clk   : in std_logic; -- Reloj maestro de la FPGA (ej. 50 MHz)
        rst   : in std_logic; -- Botón de reset general (0=pulsado, 1=libre)

        -- PUERTOS DE DEBUG (Para monitorear señales internas en el osciloscopio o simulador)
        dbg_addr     : out std_logic_vector(AW-1 downto 0); -- Dirección actual que se está procesando
        dbg_data_in  : out std_logic_vector(DW-1 downto 0); -- Dato que fluye desde la ROM hacia la RAM
        dbg_data_out : out std_logic_vector(DW-1 downto 0); -- Dato recuperado de la RAM para mostrar
        dbg_we       : out std_logic;                       -- Estado de la señal de escritura (Write Enable)
        dbg_re       : out std_logic;                       -- Estado de la señal de lectura (Read Enable)

        -- SALIDAS PARA DISPLAYS (Controlan los segmentos de los 4 visores de la FPGA)
        seg_u : out std_logic_vector(6 downto 0); -- Display 7 segmentos: dígito de UNIDADES
        seg_d : out std_logic_vector(6 downto 0); -- Display 7 segmentos: dígito de DECENAS
        seg_c : out std_logic_vector(6 downto 0); -- Display 7 segmentos: dígito de CENTENAS
        HEX3  : out std_logic_vector(6 downto 0); -- Display 7 segmentos: cuarto dígito (se mantiene apagado)

        -- PUNTOS DECIMALES (Control de los LEDs de punto en cada display)
        dp0 : out std_logic; -- Punto decimal del display de unidades
        dp1 : out std_logic; -- Punto decimal del display de decenas
        dp2 : out std_logic  -- Punto decimal del display de centenas
    );
end entity;

-- ARQUITECTURA (Define la lógica interna y la interconexión entre módulos)
architecture rtl of control_memorias is

    constant SIM : boolean := false; -- Bandera para bypass del divisor: true para simulación, false para hardware

    -- SEÑALES DE RELOJ
    signal clk_div   : std_logic; -- Reloj de baja frecuencia generado por el divisor
    signal clk_lento : std_logic; -- Reloj seleccionado para manejar la lógica (lento o rápido)

    -- SEÑALES DE CONTROL Y ESTADO
    signal estado : fsm_t := INI; -- Variable de estado para la FSM, inicia en el estado de reposo (INI)
    signal addr   : unsigned(AW-1 downto 0) := (others => '0'); -- Contador de dirección para recorrer las memorias

    -- BUSES INTERNOS DE DATOS
    signal data_rom : std_logic_vector(DW-1 downto 0); -- Bus que transporta el dato leído desde la ROM
    signal data_ram : std_logic_vector(DW-1 downto 0); -- Bus que transporta el dato leído desde la RAM

    -- HABILITADORES DE MEMORIA
    signal wr_en, rd_en : std_logic := '0'; -- Señales de escritura (wr) y lectura (rd) para la RAM

    -- SEÑALES BCD (Almacenan los valores 0-9 para cada dígito decimal)
    signal c, d, u : std_logic_vector(3 downto 0); -- c=centena, d=decena, u=unidad

    -- BUSES DE SEGMENTOS INTERNOS
    signal seg_c_i, seg_d_i, seg_u_i : std_logic_vector(6 downto 0); -- Salidas temporales de los decodificadores

    -- CONTADOR DE ESTABILIZACIÓN
    signal cont_cero : integer range 0 to 3 := 3; -- Contador para generar un retardo inicial tras el reset

begin

    ------------------------------------------------------------------
    -- DIVISOR DE FRECUENCIA
    ------------------------------------------------------------------
    -- Instancia el módulo que reduce la frecuencia para que el cambio sea visible al ojo humano
    DIV: entity work.div_frec
        port map(clk, rst, clk_div);

    -- Lógica de selección de reloj: clk_lento usa clk (50MHz) si SIM es true, de lo contrario usa clk_div
    clk_lento <= clk when SIM else clk_div;

    ------------------------------------------------------------------
    -- INSTANCIACIÓN DE MEMORIAS
    ------------------------------------------------------------------
    -- ROM síncrona: Entrega el dato pre-almacenado según la dirección 'addr'
    ROM: entity work.rom_sync
        port map(clk_lento, std_logic_vector(addr), data_rom);

    -- RAM síncrona: Guarda el dato proveniente de la ROM y permite su lectura posterior
    RAM: entity work.ram_sincrona
        port map(clk_lento, wr_en, rd_en, std_logic_vector(addr), data_rom, data_ram);

    ------------------------------------------------------------------
    -- MÁQUINA DE ESTADOS FINITOS (FSM)
    ------------------------------------------------------------------
    -- Controla secuencialmente la lectura de ROM, escritura en RAM y visualización
    process(clk_lento, rst)
    begin
        -- Reset asíncrono activo en bajo: devuelve todo a los valores de inicio
        if rst = '0' then
            estado <= INI;
            addr <= (others => '0');
            cont_cero <= 3;

        -- Operación síncrona en el flanco de subida del reloj lento
        elsif rising_edge(clk_lento) then

            case estado is

                -- Estado inicial: Genera una espera antes de empezar el ciclo
                when INI =>
                    if cont_cero > 0 then
                        cont_cero <= cont_cero - 1; -- Decrementa el contador de espera
                    else
                        addr <= (others => '0'); -- Asegura que iniciamos en la dirección 0
                        estado <= READ_ROM; -- Salta a la primera fase del proceso
                    end if;

                -- Fase de Lectura ROM: El dato se estabiliza en la salida de la ROM
                when READ_ROM =>
                    estado <= WRITE_RAM;

                -- Fase de Escritura RAM: Se activa la señal para guardar el dato en la RAM
                when WRITE_RAM =>
                    estado <= READ_RAM;

                -- Fase de Lectura RAM: Se recupera el dato recién guardado para procesarlo
                when READ_RAM =>
                    estado <= SHOW;

                -- Fase de Visualización: Se decide la siguiente dirección y se reinicia el ciclo
                when SHOW =>
                    if addr = 3 then -- Si llegamos al límite de la memoria (posiciones 0 a 3)
                        addr <= (others => '0'); -- Regresa al primer dato
                    else
                        addr <= addr + 1; -- Avanza a la siguiente posición de memoria
                    end if;

                    estado <= READ_ROM; -- Vuelve a iniciar el ciclo de transferencia

            end case;
        end if;
    end process;

    -- LÓGICA DE HABILITACIÓN (Combinacional)
    -- Activa la escritura en RAM solo en el estado WRITE_RAM y la lectura solo en READ_RAM
    wr_en <= '1' when estado = WRITE_RAM else '0';
    rd_en <= '1' when estado = READ_RAM else '0';

    ------------------------------------------------------------------
    -- CONVERSIÓN DE BINARIO A DECIMAL (BCD)
    ------------------------------------------------------------------
    -- Descompone el valor binario de 8 bits en tres dígitos decimales independientes
    process(clk_lento, rst)
    variable val : integer; -- Variable interna para realizar cálculos matemáticos
    begin
    if rst = '0' then
        c <= "0000"; d <= "0000"; u <= "0000"; -- Limpia los dígitos en reset

    elsif rising_edge(clk_lento) then

        -- Actualización controlada: solo cambia los dígitos cuando el sistema está en estado SHOW
        if estado = SHOW then
            val := to_integer(unsigned(data_ram)); -- Convierte el vector de bits a un entero

            c <= std_logic_vector(to_unsigned(val / 100, 4));        -- Obtiene las centenas (división entera)
            d <= std_logic_vector(to_unsigned((val / 10) mod 10, 4)); -- Obtiene las decenas
            u <= std_logic_vector(to_unsigned(val mod 10, 4));        -- Obtiene las unidades (residuo)
        end if;

     end if;
    end process;

    ------------------------------------------------------------------
    -- DECODIFICADORES A 7 SEGMENTOS
    ------------------------------------------------------------------
    -- Convierten los dígitos BCD (0-9) al formato físico de los displays de la FPGA
    DISP_U: entity work.seg7 port map(u, seg_u_i); -- Decodifica Unidades
    DISP_D: entity work.seg7 port map(d, seg_d_i); -- Decodifica Decenas
    DISP_C: entity work.seg7 port map(c, seg_c_i); -- Decodifica Centenas

    ------------------------------------------------------------------
    -- ASIGNACIÓN DE SALIDAS FINALES
    ------------------------------------------------------------------
    seg_u <= seg_u_i; -- Conecta el resultado de unidades al pin de salida
    seg_d <= seg_d_i; -- Conecta el resultado de decenas al pin de salida
    seg_c <= seg_c_i; -- Conecta el resultado de centenas al pin de salida

    -- APAGADO DE ELEMENTOS NO USADOS
    -- Se envía un nivel lógico alto ("1") a todos los segmentos para apagarlos (Lógica de Ánodo Común)
    HEX3 <= "1111111"; -- Apaga completamente el cuarto display

    -- Desactivación de puntos decimales (1 = apagado en la mayoría de tarjetas FPGA)
    dp0 <= '1';
    dp1 <= '1';
    dp2 <= '1';

    ------------------------------------------------------------------
    -- SEÑALES DE MONITOREO (DEBUG)
    ------------------------------------------------------------------
    -- Mapea señales internas a puertos de salida para verificación externa
    dbg_addr     <= std_logic_vector(addr); -- Muestra la dirección actual
    dbg_data_in  <= data_rom;               -- Muestra el dato que viene de la ROM
    dbg_data_out <= data_ram;               -- Muestra el dato que sale de la RAM
    dbg_we       <= wr_en;                  -- Muestra cuándo se está escribiendo
    dbg_re       <= rd_en;                  -- Muestra cuándo se está leyendo

end architecture; -- Fin de la lógica rtl
