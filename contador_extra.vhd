library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Este contador empieza a contar cuando se supera
-- el límite de 35 segundos.
-- Mide el tiempo extra.


entity contador_extra is
Port(
    clk_1s : in STD_LOGIC;          -- reloj de 1 segundo
    reset : in STD_LOGIC;           -- reinicia el contador
    activar : in STD_LOGIC;         -- activa el conteo extra
    tiempo_extra : out integer range 0 to 99
);
end contador_extra;

architecture cont_extra of contador_extra is

-- contador interno
signal cont : integer range 0 to 99 := 0;

begin

process(clk_1s, reset)
begin

-- reinicio del sistema
if reset='1' then
    cont <= 0;

-- cada segundo
elsif rising_edge(clk_1s) then

    -- si se activa el modo de tiempo extra
    if activar='1' then
        cont <= cont + 1;  -- aumenta el contador
    else
        cont <= 0;         -- si no está activo se reinicia
    end if;

end if;

end process;

-- conecta la salida
tiempo_extra <= cont;

end architecture cont_extra;