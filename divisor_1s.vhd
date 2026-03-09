library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Este módulo divide el clock de la FPGA para generar
-- una señal más lenta (1 segundo)
-- Esta señal se usará para que los contadores avancen cada segunfo

entity divisor_1s is
Port(
    clk : in STD_LOGIC;        -- clock principal de la FPGA
    reset : in STD_LOGIC;      -- reinicia el sistema
    clk_1s : out STD_LOGIC     -- salida del reloj dividido
);
end divisor_1s;

architecture divisor of divisor_1s is

-- contador interno que cuenta los ciclos del clock
signal contador : integer := 0;

-- señal interna que será la salida final
signal salida : STD_LOGIC := '0';

begin

-- proceso que se ejecuta con el clock
process(clk, reset)
begin

-- si se activa el reset
if reset='1' then
    contador <= 0;     -- reinicia el contador
    salida <= '0';     -- reinicia la salida

-- si ocurre un flanco de subida del clock
elsif rising_edge(clk) then

    -- cuando el contador llega al valor límite
    if contador = 25000000 then

        contador <= 0;       -- reinicia el contador
        salida <= not salida; -- cambia el estado de la señal

    else
        -- si no llega al límite, sigue contando
        contador <= contador + 1;
    end if;

end if;

end process;

-- conecta la señal interna con la salida del módulo
clk_1s <= salida;

end architecture divisor;