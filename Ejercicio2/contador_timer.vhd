library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

-- ENTIDAD (Define las señales de control y las salidas del conteo)

entity contador_timer is -- Nombre del módulo que gestiona el tiempo
    Port(
        clk   : in STD_LOGIC; -- Reloj 
        start : in STD_LOGIC; -- Botón de inicio (activo en bajo)
        stop  : in STD_LOGIC; -- Botón de parada (activo en bajo)
        reset : in STD_LOGIC; -- Botón de reinicio (activo en bajo)

        sec_u : out integer range 0 to 9; -- Salida para unidades de segundo
        sec_d : out integer range 0 to 5; -- Salida para decenas de segundo
        min   : out integer range 0 to 9  -- Salida para los minutos
    );
end contador_timer; -- Fin de la entidad

-- ARQUITECTURA (Lógica interna, divisor y contadores)

architecture arch_timer of contador_timer is

    -- SEÑALES INTERNAS (Registros para almacenar el tiempo y estado)

    signal su : integer range 0 to 9 := 0; -- Registro para unidades de segundo
    signal sd : integer range 0 to 5 := 0; -- Registro para decenas de segundo
    signal m  : integer range 0 to 9 := 0; -- Registro para los minutos
    signal running : STD_LOGIC := '0'; -- Bandera que indica si el cronómetro corre
    signal count_clk : integer := 0; -- Contador para el divisor de frecuencia
    signal clk_1hz   : STD_LOGIC := '0'; -- Señal de reloj de 1Hz generada

begin -- Inicio de la arquitectura

    -- DIVISOR DE FRECUENCIA (Genera 1Hz a partir de 50MHz)

    process(clk) -- Proceso sincronizado con el reloj maestro
    begin
        if rising_edge(clk) then -- En cada flanco de subida del reloj
            if count_clk = 25000000 then -- Si llega a la mitad del conteo para 1Hz
                clk_1hz <= not clk_1hz; -- Invierte el estado del reloj de 1Hz
                count_clk <= 0; -- Reinicia el contador del divisor
            else
                count_clk <= count_clk + 1; -- Incrementa el contador del divisor
            end if;
        end if;
    end process; -- Fin del proceso

    -- CONTROL DE START / STOP

    process(clk, reset) -- Proceso para gestionar el estado de ejecución
    begin
        if reset='0' then -- Si el botón reset está presionado (lógica negativa)
            running <= '0'; -- Detiene el estado de ejecución
        elsif rising_edge(clk) then -- En cada flanco de subida del reloj maestro
            if start='0' then -- Si se presiona start (lógica negativa)
                running <= '1'; -- Activa el estado de ejecución
            end if;
            if stop='0' then -- Si se presiona stop (lógica negativa)
                running <= '0'; -- Desactiva el estado de ejecución
            end if;
        end if;
    end process; -- Fin del proceso

    -- LÓGICA DEL CONTADOR DE TIEMPO (Incremento de segundos y minutos)

    process(clk_1hz, reset) -- Proceso que avanza el tiempo cada segundo
    begin
        if reset='0' then -- Si el botón reset está presionado
            su <= 0; -- Reinicia unidades de segundo a 0
            sd <= 0; -- Reinicia decenas de segundo a 0
            m  <= 0; -- Reinicia minutos a 0
        elsif rising_edge(clk_1hz) then -- En cada flanco de subida del reloj de 1Hz
            if running='1' then -- Solo incrementa si el sistema está en ejecución
                if su < 9 then -- Si las unidades son menores a 9
                    su <= su + 1; -- Incrementa las unidades
                else
                    su <= 0; -- Vuelve a 0 las unidades
                    if sd < 5 then -- Si las decenas son menores a 5
                        sd <= sd + 1; -- Incrementa las decenas
                    else
                        sd <= 0; -- Vuelve a 0 las decenas
                        if m < 9 then -- Si los minutos son menores a 9
                            m <= m + 1; -- Incrementa los minutos
                        else
                            m <= 0; -- Vuelve a 0 los minutos (tope alcanzado)
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process; -- Fin del proceso

    -- ASIGNACIÓN DE SALIDAS (Conecta registros internos a los puertos)

    sec_u <= su; -- Envía el valor de unidades a la salida
    sec_d <= sd; -- Envía el valor de decenas a la salida
    min   <= m;  -- Envía el valor de minutos a la salida

end architecture arch_timer; -- Fin de la arquitectura