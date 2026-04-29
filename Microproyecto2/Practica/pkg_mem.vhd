library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pkg_mem is
    constant DW : integer := 8;
    constant AW : integer := 2;
    constant DEPTH : integer := 4;
    type fsm_t is (INI, READ_ROM, WRITE_RAM, READ_RAM, SHOW);

    component rom_sync
        port(
            clk      : in  std_logic;
            addr     : in  std_logic_vector(AW-1 downto 0);
            data_out : out std_logic_vector(DW-1 downto 0)
        );
    end component;
end package;
