library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- MODULO PRINCIPAL
-- Integra todos los módulos del sistema:
-- divisor de frecuencia, contadores y displays


entity OcupadorEspacios is
Port(
    clk : in STD_LOGIC;        -- clock principal de la FPGA
    reset : in STD_LOGIC;      -- señal de reinicio
    ocupado : in STD_LOGIC;    -- sensor que indica si el espacio está ocupado

    seg0 : out STD_LOGIC_VECTOR(6 downto 0); -- display 1
    seg1 : out STD_LOGIC_VECTOR(6 downto 0); -- display 2
    seg2 : out STD_LOGIC_VECTOR(6 downto 0); -- display 3
    seg3 : out STD_LOGIC_VECTOR(6 downto 0); -- display 4

    led_alarma : out STD_LOGIC -- LED que indica exceso de tiempo
);
end OcupadorEspacios;

architecture OcupEsp of OcupadorEspacios is

--Componentes

component divisor_1s
Port(
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    clk_1s : out STD_LOGIC
);
end component;

component contador0_35
Port(
    clk_1s : in STD_LOGIC;
    reset : in STD_LOGIC;
    ocupado : in STD_LOGIC;
    tiempo : out integer range 0 to 35
);
end component;

component contador_extra
Port(
    clk_1s : in STD_LOGIC;
    reset : in STD_LOGIC;
    activar : in STD_LOGIC;
    tiempo_extra : out integer range 0 to 99
);
end component;

component display_7seg
Port(
    numero : in integer range 0 to 9;
    seg : out STD_LOGIC_VECTOR(6 downto 0)
);
end component;

-- SEÑALES INTERNAS


signal clk1 : STD_LOGIC;

signal t35 : integer range 0 to 35;     -- tiempo normal
signal textra : integer range 0 to 99;  -- tiempo extra

signal d1,d2,d3,d4 : integer range 0 to 9; -- dígitos para displays

signal activar_extra : STD_LOGIC;   -- activa tiempo extra
signal felicitacion : STD_LOGIC;    -- indica felicitación

begin

-- ==========================================================
-- INSTANCIAS DE MÓDULOS
-- ==========================================================

-- divisor de frecuencia (genera señal de 1 segundo)
U1: divisor_1s port map(clk,reset,clk1);

-- contador de ocupación hasta 35 segundos
U2: contador0_35 port map(clk1,reset,ocupado,t35);

-- activa contador extra cuando llega a 35
activar_extra <= '1' when t35 = 35 else '0';

-- contador de tiempo adicional
U3: contador_extra port map(clk1,reset,activar_extra,textra);

-- LED de alarma
led_alarma <= activar_extra;


-- DETECCIÓN DE FELICITACIÓN


-- se activa si la persona sale antes de 35 segundos
felicitacion <= '1' when (ocupado='0' and t35>0 and t35<35) else '0';


-- SEPARACIÓN DE DÍGITOS

-- tiempo normal
d1 <= t35 / 10;
d2 <= t35 mod 10;

-- tiempo extra
d3 <= textra / 10;
d4 <= textra mod 10;


-- CONTROL DE LOS DISPLAYS


process(felicitacion,d1,d2,d3,d4)
begin

    -- si la persona salió antes del tiempo
    if felicitacion='1' then

        -- muestra FINE en los displays
    seg0 <= "0000110"; -- E
    seg1 <= "0101011"; -- N
    seg2 <= "1111001"; -- I
    seg3 <= "0001110"; -- F

    else

        -- funcionamiento normal mostrando tiempos

        case d2 is
            when 0 => seg0 <= "1000000";
            when 1 => seg0 <= "1111001";
            when 2 => seg0 <= "0100100";
            when 3 => seg0 <= "0110000";
            when 4 => seg0 <= "0011001";
            when 5 => seg0 <= "0010010";
            when 6 => seg0 <= "0000010";
            when 7 => seg0 <= "1111000";
            when 8 => seg0 <= "0000000";
            when 9 => seg0 <= "0010000";
            when others => seg0 <= "1111111";
        end case;

        case d1 is
            when 0 => seg1 <= "1000000";
            when 1 => seg1 <= "1111001";
            when 2 => seg1 <= "0100100";
            when 3 => seg1 <= "0110000";
            when 4 => seg1 <= "0011001";
            when 5 => seg1 <= "0010010";
            when 6 => seg1 <= "0000010";
            when 7 => seg1 <= "1111000";
            when 8 => seg1 <= "0000000";
            when 9 => seg1 <= "0010000";
            when others => seg1 <= "1111111";
        end case;

        case d4 is
            when 0 => seg2 <= "1000000";
            when 1 => seg2 <= "1111001";
            when 2 => seg2 <= "0100100";
            when 3 => seg2 <= "0110000";
            when 4 => seg2 <= "0011001";
            when 5 => seg2 <= "0010010";
            when 6 => seg2 <= "0000010";
            when 7 => seg2 <= "1111000";
            when 8 => seg2 <= "0000000";
            when 9 => seg2 <= "0010000";
            when others => seg2 <= "1111111";
        end case;

        case d3 is
            when 0 => seg3 <= "1000000";
            when 1 => seg3 <= "1111001";
            when 2 => seg3 <= "0100100";
            when 3 => seg3 <= "0110000";
            when 4 => seg3 <= "0011001";
            when 5 => seg3 <= "0010010";
            when 6 => seg3 <= "0000010";
            when 7 => seg3 <= "1111000";
            when 8 => seg3 <= "0000000";
            when 9 => seg3 <= "0010000";
            when others => seg3 <= "1111111";
        end case;

    end if;

end process;

end architecture OcupEsp;