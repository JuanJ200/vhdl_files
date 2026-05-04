library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic
use IEEE.NUMERIC_STD.ALL; -- Permite realizar conversiones para los reportes de consola

-- ENTIDAD DEL TESTBENCH 
entity tb_control_memorias is
end entity;

-- ARQUITECTURA DE SIMULACIÓN (Define los estímulos para probar el diseño)
architecture sim of tb_control_memorias is

    -- SEÑALES DE ESTIMULACIÓN (Conectan a las entradas del DUT)
    signal clk : std_logic := '0'; -- Señal de reloj inicializada en bajo
    signal rst : std_logic := '0'; -- Señal de reset inicializada en activo (bajo)

    -- SEÑALES DE OBSERVACIÓN (Conectan a las salidas de DEBUG del DUT)
    signal addr     : std_logic_vector(1 downto 0); -- Monitorea la dirección de memoria actual
    signal data_in  : std_logic_vector(7 downto 0); -- Monitorea el dato que entra a la RAM
    signal data_out : std_logic_vector(7 downto 0); -- Monitorea el dato que sale de la RAM
    signal we, re   : std_logic;                    -- Monitorea los habilitadores de escritura y lectura

    -- SEÑALES DE SALIDA VISUAL (Conectan a los displays del DUT)
    signal seg_u, seg_d, seg_c : std_logic_vector(6 downto 0); -- Monitorea los segmentos de los displays

begin

    -- INSTANCIACIÓN DEL DISEÑO BAJO PRUEBA (DUT - Device Under Test)
    -- Se conecta el módulo principal 'control_memorias' para verificar su comportamiento
    DUT: entity work.control_memorias
        port map(
            clk => clk, -- Conexión del reloj de simulación
            rst => rst, -- Conexión del reset de simulación

            -- Mapeo de puertos de depuración (DEBUG)
            dbg_addr     => addr,
            dbg_data_in  => data_in,
            dbg_data_out => data_out,
            dbg_we       => we,
            dbg_re       => re,

            -- Mapeo de puertos de visualización
            seg_u => seg_u,
            seg_d => seg_d,
            seg_c => seg_c
        );

    ------------------------------------------------------------------
    -- GENERACIÓN DE RELOJ (Clock Process)
    ------------------------------------------------------------------
    -- Crea una señal cuadrada con un periodo de 20 ns (50 MHz)
    process
    begin
        while true loop -- Bucle infinito de oscilación
            clk <= '0'; wait for 10 ns; -- Mantener en bajo 10 ns
            clk <= '1'; wait for 10 ns; -- Mantener en alto 10 ns
        end loop;
    end process;

    ------------------------------------------------------------------
    -- GENERACIÓN DE ESTÍMULOS (Stimulus Process)
    ------------------------------------------------------------------
    -- Controla el ciclo de vida de la simulación
    process
    begin
        -- FASE 1: Aplicación de Reset inicial
        rst <= '0';         -- Activa el reset
        wait for 50 ns;     -- Espera estable para asegurar la inicialización
        
        -- FASE 2: Liberación del Reset
        rst <= '1';         -- Desactiva el reset para iniciar la FSM

        -- FASE 3: Ejecución de la prueba
        -- Se deja correr la simulación por 2 ms para observar varios ciclos de la FSM
        wait for 2 ms;

        -- Finalización de la simulación (detiene el proceso)
        wait; 
    end process;

    ------------------------------------------------------------------
    -- MONITOR DE CONSOLA (Monitor Process)
    ------------------------------------------------------------------
    -- Imprime en la consola de simulación el estado del sistema en cada ciclo de reloj
    process(clk)
    begin
        if rising_edge(clk) then -- Se activa en cada flanco de subida
            -- Reporte detallado de buses y señales de control
            report "ADDR=" & integer'image(to_integer(unsigned(addr))) &
                   " | DIN=" & integer'image(to_integer(unsigned(data_in))) &
                   " | DOUT=" & integer'image(to_integer(unsigned(data_out))) &
                   " | WE=" & std_logic'image(we) &
                   " | RE=" & std_logic'image(re);
        end if;
    end process;

end architecture; -- Fin de la arquitectura de simulación
