library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic

-- ENTIDAD (Define el inicio del conteo después de los 35 segundos)

entity contador_extra is -- Nombre del módulo para tiempo adicional
    Port(
        clk_1s       : in STD_LOGIC; -- Reloj de 1 segundo
        reset        : in STD_LOGIC; -- Reinicio del contador extra
        activar      : in STD_LOGIC; -- Señal que habilita el tiempo extra
        tiempo_extra : out integer range 0 to 99 -- Salida de tiempo de exceso
    );
end contador_extra; -- Fin de la entidad

-- ARQUITECTURA (Lógica de incremento para tiempo de exceso)

architecture cont_extra of contador_extra is

    -- SEÑALES INTERNAS (Registro para segundos acumulados)

    signal cont : integer range 0 to 99 := 0; -- Almacena el exceso hasta 99

begin -- Inicio de la arquitectura

    -- PROCESO DE TIEMPO EXTRA

    process(clk_1s, reset) -- Sincronizado con el reloj de 1s y reset
    begin
        if reset='1' then -- Si se solicita un reinicio del sistema
            cont <= 0; -- Limpia el contador de tiempo extra
        elsif rising_edge(clk_1s) then -- En cada segundo que pasa
            if activar='1' then -- Si el modo de tiempo extra está habilitado
                cont <= cont + 1; -- Comienza a acumular el tiempo de exceso
            else
                cont <= 0; -- Si se desactiva el modo, vuelve a cero
            end if;
        end if;
    end process; -- Fin del proceso

    -- ASIGNACIÓN DE SALIDA

    tiempo_extra <= cont; -- Conecta el acumulador interno con la salida

end architecture cont_extra; -- Fin de la arquitectura