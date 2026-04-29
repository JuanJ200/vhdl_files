library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_control_mem is
end;

architecture sim of tb_control_mem is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal re, we : std_logic;
    signal addr : std_logic_vector(1 downto 0);
    signal data_in, data_out : std_logic_vector(7 downto 0);
    signal su, sd, sc : std_logic_vector(6 downto 0);
begin
    DUT: entity work.control_memorias
        port map(clk, rst, re, we, addr, data_in, data_out, su, sd, sc);

    clk_process: process begin
        clk <= '0'; wait for 10 ms;
        clk <= '1'; wait for 10 ms;
    end process;

    stim: process begin
        rst <= '0'; wait for 30 ms;
        rst <= '1'; wait for 500 ms;
        wait;
    end process;
end architecture;
