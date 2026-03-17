library IEEE; -- Se importa la librería estándar IEEE
use IEEE.STD_LOGIC_1164.ALL; -- Permite usar señales digitales como std_logic
use IEEE.NUMERIC_STD.ALL; -- Permite hacer operaciones matemáticas y conversiones

-- ENTIDAD (Define la entrada de alta frecuencia y la salida de 1 segundo)

entity divisor_1s is -- Nombre del módulo divisor de frecuencia
    Port(
        clk    : in STD_LOGIC; -- Reloj principal de la FPGA (ej. 50MHz)
        reset  : in STD_LOGIC; -- Señal para reiniciar el divisor
        clk_1s : out STD_LOGIC -- Salida del reloj lento de 1 segundo
    );
end divisor_1s; -- Fin de la entidad

-- ARQUITECTURA (Lógica para reducir la frecuencia del reloj)

architecture divisor of divisor_1s is

    -- SEÑALES INTERNAS (Variables para el conteo y estado)

    signal contador : integer := 0; -- Acumulador de ciclos de reloj
    signal salida   : STD_LOGIC := '0'; -- Registro interno para la señal de salida

begin -- Inicio de la arquitectura

    -- PROCESO DEL DIVISOR (Cuenta ciclos para generar el pulso)

    process(clk, reset) -- Proceso sincronizado con el reloj y reset
    begin
        if reset='1' then -- Si se activa el reset (lógica positiva)
            contador <= 0; -- Reinicia el acumulador a cero
            salida <= '0'; -- Reinicia la señal de salida a bajo
        elsif rising_edge(clk) then -- En cada flanco de subida del reloj maestro
            if contador = 25000000 then -- Si llega al límite (para 50MHz a 1Hz)
                contador <= 0; -- Reinicia el acumulador
                salida <= not salida; -- Invierte el estado de la señal (toggle)
            else
                contador <= contador + 1; -- Incrementa el contador de ciclos
            end if;
        end if;
    end process; -- Fin del proceso

    -- ASIGNACIÓN DE SALIDA

    clk_1s <= salida; -- Conecta la señal interna al puerto de salida

end architecture divisor; -- Fin de la arquitectura