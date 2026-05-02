library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity tb_control_mem is end entity;
architecture sim of tb_control_mem is
    signal clk : std_logic := '0'; signal rst : std_logic := '0';
    signal su, sd, sc : std_logic_vector(6 downto 0);
begin
    DUT: entity work.control_memorias port map(clk, rst, su, sd, sc);
    clk_process: process begin
        while true loop
            clk <= '0'; wait for 10 ms;
            clk <= '1'; wait for 10 ms;
        end loop;
    end process;
    stim: process begin
        rst <= '0'; wait for 30 ms;
        rst <= '1'; wait for 500 ms;
        assert false report "Simulacion OK" severity note; wait;
    end process;
end architecture;
