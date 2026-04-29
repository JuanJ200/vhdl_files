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