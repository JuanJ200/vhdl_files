library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mem.all; 
use IEEE.NUMERIC_STD.ALL;

entity control_memorias is
    port(clk, rst: in std_logic; seg_u, seg_d, seg_c: out std_logic_vector(6 downto 0));
end entity;
architecture rtl of control_memorias is
    signal estado, sig_estado : fsm_t;
    signal rom_data, ram_data : std_logic_vector(7 downto 0);
    signal we_s, re_s : std_logic;
    signal dir : unsigned(1 downto 0) := (others => '0');
    signal u, d, c : std_logic_vector(3 downto 0);
begin
    ROM1: entity work.rom_sync port map(clk, std_logic_vector(dir), rom_data);
    RAM1: entity work.ram_sincrona port map(clk, we_s, re_s, std_logic_vector(dir), rom_data, ram_data);
    we_s <= '1' when estado = WRITE_RAM else '0';
    re_s <= '1' when estado = READ_RAM or estado = SHOW else '0';
    process(clk, rst) begin
        if rst = '0' then estado <= INI; dir <= (others => '0');
        elsif rising_edge(clk) then estado <= sig_estado;
            if estado = SHOW then
                if dir = "11" then dir <= (others => '0');
                else dir <= dir + 1; end if;
            end if;
        end if;
    end process;
    process(estado) begin
        case estado is
            when INI => sig_estado <= READ_ROM;
            when READ_ROM => sig_estado <= WRITE_RAM;
            when WRITE_RAM => sig_estado <= READ_RAM;
            when READ_RAM => sig_estado <= SHOW;
            when SHOW => sig_estado <= READ_ROM;
        end case;
    end process;
    process(ram_data) begin
        case ram_data is
            when "00010010" => c <= "0000"; d <= "0001"; u <= "1000";
            when "11001010" => c <= "0010"; d <= "0000"; u <= "0010";
            when "00000111" => c <= "0000"; d <= "0000"; u <= "0111";
            when "10101111" => c <= "0001"; d <= "0111"; u <= "0101";
            when others => c <= "0000"; d <= "0000"; u <= "0000";
        end case;
    end process;
    U1: entity work.seg7 port map(u, seg_u);
    D1: entity work.seg7 port map(d, seg_d);
    C1: entity work.seg7 port map(c, seg_c);
end architecture;
