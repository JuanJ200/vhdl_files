library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_control_memorias is
end;

architecture sim of tb_control_memorias is

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal addr     : std_logic_vector(1 downto 0);
    signal data_in  : std_logic_vector(7 downto 0);
    signal data_out : std_logic_vector(7 downto 0);
    signal we, re   : std_logic;

    signal seg_u, seg_d, seg_c : std_logic_vector(6 downto 0);

begin

    DUT: entity work.control_memorias
        port map(
            clk => clk,
            rst => rst,

            dbg_addr     => addr,
            dbg_data_in  => data_in,
            dbg_data_out => data_out,
            dbg_we       => we,
            dbg_re       => re,

            seg_u => seg_u,
            seg_d => seg_d,
            seg_c => seg_c
        );

    -- clock
    process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    -- estímulo
    process
    begin
        rst <= '0';
        wait for 50 ns;
        rst <= '1';

        wait for 2 ms;

        wait;
    end process;

    -- monitor
    process(clk)
    begin
        if rising_edge(clk) then
            report "ADDR=" & integer'image(to_integer(unsigned(addr))) &
                   " | DIN=" & integer'image(to_integer(unsigned(data_in))) &
                   " | DOUT=" & integer'image(to_integer(unsigned(data_out))) &
                   " | WE=" & std_logic'image(we) &
                   " | RE=" & std_logic'image(re);
        end if;
    end process;

end sim;
