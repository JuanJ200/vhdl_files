library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic
use IEEE.NUMERIC_STD.ALL; -- Permite operaciones matemáticas

-- ENTIDAD PRINCIPAL (Módulo con control por botón)

entity timer_two is -- Nombre del módulo principal
    Port(
        clk : in STD_LOGIC; -- Reloj maestro de entrada
        btn : in STD_LOGIC; -- Botón para start/stop/reset

        seg0 : out STD_LOGIC_VECTOR(6 downto 0); -- Salida Display unidades
        seg1 : out STD_LOGIC_VECTOR(6 downto 0); -- Salida Display decenas
        seg2 : out STD_LOGIC_VECTOR(6 downto 0); -- Salida Display minutos

        dp2 : out STD_LOGIC -- Punto decimal para el display de minutos
    );
end timer_two; -- Fin de la entidad

-- ARQUITECTURA (Configuración de divisor, botón e instancias)

architecture arch_t of timer_two is

    -- SEÑALES INTERNAS (Cables y registros del sistema)

    signal su : integer range 0 to 9; -- Cable para unidades de segundo
    signal sd : integer range 0 to 5; -- Cable para decenas de segundo
    signal m  : integer range 0 to 9; -- Cable para minutos
    signal enable : STD_LOGIC := '0'; -- Registro de estado (correr/pausa)
    signal s_reset : STD_LOGIC := '0'; -- Señal de reset interna
    signal clk_1hz : STD_LOGIC := '0'; -- Reloj dividido de 1Hz
    signal div_cnt : integer := 0; -- Contador para el divisor de frecuencia
    signal press_cnt : integer := 0; -- Contador para medir tiempo de pulsación
    signal btn_prev  : STD_LOGIC := '1'; -- Registro del estado anterior del botón

    -- COMPONENTE CONTADOR LÓGICO

    component timer_counter -- Declaración del contador
    Port(
        clk    : in STD_LOGIC; -- Entrada de reloj
        enable : in STD_LOGIC; -- Entrada de habilitación
        reset  : in STD_LOGIC; -- Entrada de reinicio
        sec_u  : out integer range 0 to 9; -- Salida unidades
        sec_d  : out integer range 0 to 5; -- Salida decenas
        min    : out integer range 0 to 9  -- Salida minutos
    );
    end component; -- Fin del componente

    -- COMPONENTE DECODIFICADOR 7 SEGMENTOS

    component decoder7seg -- Declaración del decodificador
    Port(
        num : in integer range 0 to 9; -- Número de entrada
        seg : out STD_LOGIC_VECTOR(6 downto 0) -- Salida a segmentos
    );
    end component; -- Fin del componente

begin -- Inicio de la arquitectura

    -- PROCESO DIVISOR DE FRECUENCIA (50MHz a 1Hz)

    process(clk) -- Proceso sincronizado con el reloj maestro
    begin
        if rising_edge(clk) then -- En cada flanco de subida
            if div_cnt = 24999999 then -- Si alcanza el conteo de medio segundo
                clk_1hz <= not clk_1hz; -- Invierte el estado del reloj
                div_cnt <= 0; -- Reinicia el contador del divisor
            else
                div_cnt <= div_cnt + 1; -- Incrementa el contador del divisor
            end if;
        end if;
    end process; -- Fin del proceso

    -- PROCESO DE CONTROL DEL BOTÓN (Detección de pulsación corta y larga)

    process(clk) -- Proceso para gestionar el botón único
    begin
        if rising_edge(clk) then -- Sincronizado con reloj principal
            s_reset <= '0'; -- Reset interno por defecto en '0'
            if btn_prev = '1' and btn = '0' then -- Si detecta que se presiona el botón
                press_cnt <= 0; -- Inicia el conteo de tiempo de pulsación
            end if;
            if btn = '0' then -- Mientras el botón se mantiene presionado
                press_cnt <= press_cnt + 1; -- Incrementa contador de tiempo
                if press_cnt >= 100000000 then -- Si se mantiene por 2 segundos (a 50MHz)
                    s_reset <= '1'; -- Activa señal de reinicio
                    enable <= '0'; -- Detiene el avance del tiempo
                end if;
            else -- Cuando se suelta el botón
                if btn_prev = '0' then -- Si venía de estar presionado
                    if press_cnt < 100000000 then -- Si fue una pulsación corta
                        enable <= not enable; -- Alterna entre inicio y pausa
                    end if;
                end if;
                press_cnt <= 0; -- Reinicia contador de pulsación
            end if;
            btn_prev <= btn; -- Actualiza el estado anterior del botón
        end if;
    end process; -- Fin del proceso

    -- INSTANCIA DEL CONTADOR

    counter_inst: timer_counter -- Conexión del bloque contador
    port map(
        clk    => clk_1hz, -- Usa el reloj de 1Hz
        enable => enable, -- Conecta señal enable
        reset  => s_reset, -- Conecta señal reset
        sec_u  => su, -- Conecta salida a cable su
        sec_d  => sd, -- Conecta salida a cable sd
        min    => m -- Conecta salida a cable m
    );

    -- INSTANCIAS DE LOS DECODIFICADORES PARA DISPLAYS

    disp0: decoder7seg port map(su, seg0); -- Decodifica unidades para seg0
    disp1: decoder7seg port map(sd, seg1); -- Decodifica decenas para seg1
    disp2: decoder7seg port map(m, seg2);  -- Decodifica minutos para seg2

    dp2 <= '0'; -- Punto decimal encendido para marcar los minutos

end architecture arch_t; -- Fin de la arquitectura