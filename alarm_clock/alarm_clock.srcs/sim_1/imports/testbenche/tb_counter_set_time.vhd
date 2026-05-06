library ieee;
use ieee.std_logic_1164.all;

entity tb_counter_set_time is
end tb_counter_set_time;

architecture tb of tb_counter_set_time is
constant c_G_BITS : positive := 4;
    component counter_set_time
    generic (
            G_BITS : positive
        );
        port (clk    : in std_logic;
              rst    : in std_logic;
              en     : in std_logic;
              cnt2hd : out std_logic_vector (G_BITS - 1 downto 0);
              cnt2hj : out std_logic_vector (G_BITS - 1 downto 0);
              cnt2md : out std_logic_vector (G_BITS - 1 downto 0);
              cnt2mj : out std_logic_vector (G_BITS - 1 downto 0);
              switch : in std_logic);
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal en     : std_logic;
    signal cnt2hd : std_logic_vector (c_G_BITS - 1 downto 0);
    signal cnt2hj : std_logic_vector (c_G_BITS - 1 downto 0);
    signal cnt2md : std_logic_vector (c_G_BITS - 1 downto 0);
    signal cnt2mj : std_logic_vector (c_G_BITS - 1 downto 0);
    signal switch : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter_set_time
      generic map (
        G_BITS => c_G_BITS
    )
    port map (clk    => clk,
              rst    => rst,
              en     => en,
              cnt2hd => cnt2hd,
              cnt2hj => cnt2hj,
              cnt2md => cnt2md,
              cnt2mj => cnt2mj,
              switch => switch);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- Inicializace
        en <= '0';
        switch <= '0';

        -- Reset (aspoň na chvíli podržíme jedničku, pak nula)
        rst <= '1';
        wait for 20 ns; 
        rst <= '0';
        wait for 20 ns;

        -- ZAPNUTÍ ČÍTAČE (bez tohohle by to nepočítalo!)
        en <= '1';
        
        -- Necháme počítat HODINY (switch = '0') po dobu 50 taktů hodin
        -- Během této doby bys měl vidět, jak se hodiny krokují a po 23 se resetují
        wait for 50 * TbPeriod;

        -- Přepneme na počítání MINUT (switch = '1')
        switch <= '1';
        
        -- Necháme počítat MINUTY po dobu dalších 150 taktů hodin
        -- Měl bys vidět, jak minuty dojdou na 59 a pak se resetují na 00
        wait for 150 * TbPeriod;

        -- Zastavení simulace
        TbSimEnded <= '1';
        wait;
    end process;
end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter_nastavitelny of tb_counter_nastavitelny is
    for tb
    end for;
end cfg_tb_counter_nastavitelny;