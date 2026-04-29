library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_mem.all;

entity ram_sincrona is
    port(
        clk      : in std_logic;
        wr_en    : in std_logic;
        rd_en    : in std_logic;
        addr     : in std_logic_vector(AW-1 downto 0);
        data_in  : in std_logic_vector(DW-1 downto 0);
        data_out : out std_logic_vector(DW-1 downto 0)
    );
end;

architecture rtl of ram_sincrona is
    type ram_array is array (0 to DEPTH-1) of std_logic_vector(DW-1 downto 0);
    signal RAM : ram_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                RAM(to_integer(unsigned(addr))) <= data_in;
            end if;
            if rd_en = '1' then
                data_out <= RAM(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;
end rtl;
