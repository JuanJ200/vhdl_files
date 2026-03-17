library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic

-- ENTIDAD (Define entradas de control y salidas de conteo)

entity timer_counter is -- Nombre del componente contador
    Port(
        clk    : in STD_LOGIC; -- Reloj de entrada (ya dividido a 1Hz)
        enable : in STD_LOGIC; -- Señal para activar/pausar el conteo
        reset  : in STD_LOGIC; -- Señal de reinicio del contador

        sec_u : out integer range 0 to 9; -- Salida de unidades de segundo
        sec_d : out integer range 0 to 5; -- Salida de decenas de segundo
        min   : out integer range 0 to 9  -- Salida de minutos
    );
end timer_counter; -- Fin de la entidad

-- ARQUITECTURA (Lógica interna del contador de tiempo)

architecture arch_count of timer_counter is

    -- SEÑALES INTERNAS (Registros para el tiempo)

    signal su : integer range 0 to 9 := 0; -- Registro para unidades de segundo
    signal sd : integer range 0 to 5 := 0; -- Registro para decenas de segundo
    signal m  : integer range 0 to 9 := 0; -- Registro para minutos

begin -- Inicio de la arquitectura

    -- PROCESO DE CONTROL DE TIEMPO

    process(clk, reset) -- Proceso sensible al reloj y al reset
    begin
        if reset = '1' then -- Si el reset está activado (lógica positiva)
            su <= 0; -- Reinicia unidades de segundo
            sd <= 0; -- Reinicia decenas de segundo
            m  <= 0; -- Reinicia minutos
        elsif rising_edge(clk) then -- En cada flanco de subida del reloj
            if enable = '1' then -- Si el conteo está habilitado
                if su < 9 then -- Si las unidades no han llegado a 9
                    su <= su + 1; -- Incrementa unidad de segundo
                else
                    su <= 0; -- Reinicia unidades de segundo
                    if sd < 5 then -- Si las decenas no han llegado a 5
                        sd <= sd + 1; -- Incrementa decena de segundo
                    else
                        sd <= 0; -- Reinicia decenas de segundo
                        if m < 9 then -- Si los minutos no han llegado a 9
                            m <= m + 1; -- Incrementa los minutos
                        else
                            m <= 0; -- Reinicia los minutos
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process; -- Fin del proceso

    -- ASIGNACIÓN DE SALIDAS

    sec_u <= su; -- Conecta registro interno a salida de unidades
    sec_d <= sd; -- Conecta registro interno a salida de decenas
    min   <= m;  -- Conecta registro interno a salida de minutos

end architecture arch_count; -- Fin de la arquitectura