library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram_sincrona is
    port(
        clk      : in std_logic;
        wr_en    : in std_logic;
        addr     : in std_logic_vector(1 downto 0);
        data_in  : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end;

architecture rtl of ram_sincrona is
begin
end rtl;