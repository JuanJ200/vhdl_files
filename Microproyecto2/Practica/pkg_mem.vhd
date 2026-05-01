library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pkg_mem is

    constant DW : integer := 8;
    constant AW : integer := 2;
    constant DEPTH : integer := 4;

    type fsm_t is (INI, READ_ROM, WRITE_RAM, READ_RAM, SHOW);

end package;
