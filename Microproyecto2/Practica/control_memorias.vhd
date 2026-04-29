library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_mem.all;

entity control_memorias is
    port(
        clk      : in  std_logic;
        rst      : in  std_logic;
        seg_u    : out std_logic_vector(6 downto 0)
    );
end;
    architecture rtl of control_memorias is
    signal estado, sig_estado : fsm_t;
    signal dir : unsigned(AW-1 downto 0) := (others => '0');
    signal rom_data, ram_data : std_logic_vector(DW-1 downto 0);
begin
    process(clk, rst) begin
        if rst = '0' then estado <= INI;
        elsif rising_edge(clk) then estado <= sig_estado;
        end if;
    end process;
end rtl;
            process(estado) begin
        case estado is
            when INI       => sig_estado <= READ_ROM;
            when READ_ROM  => sig_estado <= WRITE_RAM;
            when WRITE_RAM => sig_estado <= READ_RAM;
            when READ_RAM  => sig_estado <= SHOW;
            when SHOW      => sig_estado <= READ_ROM;
        end case;
    end process;
