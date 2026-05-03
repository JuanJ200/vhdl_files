library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_mem.all;

entity control_memorias is
    port(
        clk   : in std_logic;
        rst   : in std_logic;

        
        dbg_addr     : out std_logic_vector(AW-1 downto 0);
        dbg_data_in  : out std_logic_vector(DW-1 downto 0);
        dbg_data_out : out std_logic_vector(DW-1 downto 0);
        dbg_we       : out std_logic;
        dbg_re       : out std_logic;

        
        seg_u : out std_logic_vector(6 downto 0);
        seg_d : out std_logic_vector(6 downto 0);
        seg_c : out std_logic_vector(6 downto 0);
        HEX3  : out std_logic_vector(6 downto 0); 

        
        dp0 : out std_logic;
        dp1 : out std_logic;
        dp2 : out std_logic
    );
end;

architecture rtl of control_memorias is

    constant SIM : boolean := false;

    signal clk_div   : std_logic;
    signal clk_lento : std_logic;

    signal estado : fsm_t := INI;
    signal addr   : unsigned(AW-1 downto 0) := (others => '0');

    signal data_rom : std_logic_vector(DW-1 downto 0);
    signal data_ram : std_logic_vector(DW-1 downto 0);

    signal wr_en, rd_en : std_logic := '0';

    signal c, d, u : std_logic_vector(3 downto 0);

    signal seg_c_i, seg_d_i, seg_u_i : std_logic_vector(6 downto 0);

    signal cont_cero : integer range 0 to 3 := 3;

begin

   
    DIV: entity work.div_frec
        port map(clk, rst, clk_div);

    clk_lento <= clk when SIM else clk_div;


    ROM: entity work.rom_sync
        port map(clk_lento, std_logic_vector(addr), data_rom);

    RAM: entity work.ram_sincrona
        port map(clk_lento, wr_en, rd_en, std_logic_vector(addr), data_rom, data_ram);

    process(clk_lento, rst)
    begin
        if rst = '0' then
            estado <= INI;
            addr <= (others => '0');
            cont_cero <= 3;

        elsif rising_edge(clk_lento) then

            case estado is

                when INI =>
                    if cont_cero > 0 then
                        cont_cero <= cont_cero - 1;
                    else
                        addr <= (others => '0');
                        estado <= READ_ROM;
                    end if;

                when READ_ROM =>
                    estado <= WRITE_RAM;

                when WRITE_RAM =>
                    estado <= READ_RAM;

                when READ_RAM =>
                    estado <= SHOW;

                when SHOW =>
                    if addr = 3 then
                        addr <= (others => '0');
                    else
                        addr <= addr + 1;
                    end if;

                    estado <= READ_ROM;

            end case;
        end if;
    end process;

    wr_en <= '1' when estado = WRITE_RAM else '0';
    rd_en <= '1' when estado = READ_RAM else '0';

   
    process(clk_lento, rst)
    variable val : integer;
    begin
    if rst = '0' then
        c <= "0000";
        d <= "0000";
        u <= "0000";

    elsif rising_edge(clk_lento) then

        
        if estado = SHOW then
            val := to_integer(unsigned(data_ram));

            c <= std_logic_vector(to_unsigned(val / 100, 4));
            d <= std_logic_vector(to_unsigned((val / 10) mod 10, 4));
            u <= std_logic_vector(to_unsigned(val mod 10, 4));
        end if;

     end if;
    end process;

 
    DISP_U: entity work.seg7 port map(u, seg_u_i);
    DISP_D: entity work.seg7 port map(d, seg_d_i);
    DISP_C: entity work.seg7 port map(c, seg_c_i);

    
    seg_u <= seg_u_i;
    seg_d <= seg_d_i;
    seg_c <= seg_c_i;

    
    HEX3 <= "1111111";

    
    dp0 <= '1';
    dp1 <= '1';
    dp2 <= '1';

    
    dbg_addr     <= std_logic_vector(addr);
    dbg_data_in  <= data_rom;
    dbg_data_out <= data_ram;
    dbg_we       <= wr_en;
    dbg_re       <= rd_en;

end rtl;
