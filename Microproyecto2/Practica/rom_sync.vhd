library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_mem.all;

entity rom_sync is
    port(
        clk      : in  std_logic;
        addr     : in  std_logic_vector(AW-1 downto 0);
        data_out : out std_logic_vector(DW-1 downto 0)
    );
end;

architecture rtl of rom_sync is

    type rom_array is array (0 to DEPTH-1) of std_logic_vector(DW-1 downto 0);

    constant ROM : rom_array := (
        "00010010", -- 18
        "11001010", -- 202
        "00000111", -- 7
        "10101111"  -- 175
    );

begin

    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= ROM(to_integer(unsigned(addr)));
        end if;
    end process;

end rtl;
