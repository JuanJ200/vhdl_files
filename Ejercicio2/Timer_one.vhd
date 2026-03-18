library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 

-- ENTIDAD PRINCIPAL (Conecta los componentes con los pines de la FPGA)

entity timer_one is 
    Port(
        clk   : in STD_LOGIC; -- Entrada del reloj maestro
        start : in STD_LOGIC; -- Entrada del botón start
        stop  : in STD_LOGIC; -- Entrada del botón stop
        reset : in STD_LOGIC; -- Entrada del botón reset

        seg0 : out STD_LOGIC_VECTOR(6 downto 0); -- Salida Display 0 (Unidades Seg)
        seg1 : out STD_LOGIC_VECTOR(6 downto 0); -- Salida Display 1 (Decenas Seg)
        seg2 : out STD_LOGIC_VECTOR(6 downto 0); -- Salida Display 2 (Minutos)

        dp : out STD_LOGIC  -- Punto decimal del Display 2
    );
end timer_one; 

-- ARQUITECTURA (Instanciación y cableado de componentes)

architecture arch_timer of timer_one is

    -- SEÑALES INTERNAS (Cables para conectar el contador con los displays)

    signal su : integer range 0 to 9; -- Cable para las unidades de segundo
    signal sd : integer range 0 to 5; -- Cable para las decenas de segundo
    signal m  : integer range 0 to 9; -- Cable para los minutos

    -- COMPONENTE CONTADOR (Lógica de tiempo)

    component contador_timer -- Declaración del módulo contador
    Port(
        clk   : in STD_LOGIC; -- Entrada de reloj
        start : in STD_LOGIC; -- Entrada start
        stop  : in STD_LOGIC; -- Entrada stop
        reset : in STD_LOGIC; -- Entrada reset
        sec_u : out integer range 0 to 9; -- Salida unidades
        sec_d : out integer range 0 to 5; -- Salida decenas
        min   : out integer range 0 to 9  -- Salida minutos
    );
    end component; -- Fin del componente

    -- COMPONENTE DISPLAY (Decodificador 7 segmentos)

    component display7seg -- Declaración del módulo decodificador
    Port(
        num : in integer range 0 to 9; -- Entrada numérica
        seg : out STD_LOGIC_VECTOR(6 downto 0) -- Salida a los segmentos
    );
    end component; -- Fin del componente

begin -- Inicio de la arquitectura

    -- INSTANCIA DEL CONTADOR PRINCIPAL

    contador: contador_timer -- Se crea el bloque lógico del tiempo
    port map(
        clk   => clk, -- Conecta reloj maestro
        start => start, -- Conecta botón start
        stop  => stop, -- Conecta botón stop
        reset => reset, -- Conecta botón reset
        sec_u => su, -- Conecta salida de unidades al cable interno su
        sec_d => sd, -- Conecta salida de decenas al cable interno sd
        min   => m -- Conecta salida de minutos al cable interno m
    );

    -- INSTANCIA DEL DISPLAY 0 (Unidades de Segundo)

    disp0: display7seg -- Se crea el decodificador para el primer dígito
    port map(
        num => su, -- Recibe el valor del cable su
        seg => seg0 -- Envía el patrón al puerto físico seg0
    );

    -- INSTANCIA DEL DISPLAY 1 (Decenas de Segundo)

    disp1: display7seg -- Se crea el decodificador para el segundo dígito
    port map(
        num => sd, -- Recibe el valor del cable sd
        seg => seg1 -- Envía el patrón al puerto físico seg1
    );

    -- INSTANCIA DEL DISPLAY 2 (Minutos)

    disp2: display7seg -- Se crea el decodificador para el tercer dígito
    port map(
        num => m, -- Recibe el valor del cable m
        seg => seg2 -- Envía el patrón al puerto físico seg2
    );

    -- CONFIGURACIÓN DEL PUNTO DECIMAL

    dp <= '0'; -- El punto del display 2 se enciende (divisor minutos/segundos)

end architecture arch_timer; -- Fin de la arquitectura
