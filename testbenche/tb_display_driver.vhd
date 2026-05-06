-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 20 Apr 2026 16:40:30 GMT
-- Request id : cfwk-fed377c2-69e656fe28b3d

library ieee;
use ieee.std_logic_1164.all;

entity tb_display_driver is
end tb_display_driver;

architecture tb of tb_display_driver is

    component display_driver
        port (clk     : in std_logic;
              rst     : in std_logic;
              h_des   : in std_logic_vector (3 downto 0);
              h_jed   : in std_logic_vector (3 downto 0);
              m_des   : in std_logic_vector (3 downto 0);
              m_jed   : in std_logic_vector (3 downto 0);
              ah_des  : in std_logic_vector (3 downto 0);
              ah_jed  : in std_logic_vector (3 downto 0);
              am_des  : in std_logic_vector (3 downto 0);
              am_jed  : in std_logic_vector (3 downto 0);
              clk_1hz : in std_logic;
              seg     : out std_logic_vector (6 downto 0);
              an      : out std_logic_vector (7 downto 0);
              dp      : out std_logic);
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal h_des   : std_logic_vector (3 downto 0);
    signal h_jed   : std_logic_vector (3 downto 0);
    signal m_des   : std_logic_vector (3 downto 0);
    signal m_jed   : std_logic_vector (3 downto 0);
    signal ah_des  : std_logic_vector (3 downto 0);
    signal ah_jed  : std_logic_vector (3 downto 0);
    signal am_des  : std_logic_vector (3 downto 0);
    signal am_jed  : std_logic_vector (3 downto 0);
    signal clk_1hz : std_logic;
    signal seg     : std_logic_vector (6 downto 0);
    signal an      : std_logic_vector (7 downto 0);
    signal dp      : std_logic;

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver
    port map (clk     => clk,
              rst     => rst,
              h_des   => h_des,
              h_jed   => h_jed,
              m_des   => m_des,
              m_jed   => m_jed,
              ah_des  => ah_des,
              ah_jed  => ah_jed,
              am_des  => am_des,
              am_jed  => am_jed,
              clk_1hz => clk_1hz,
              seg     => seg,
              an      => an,
              dp      => dp);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        h_des <= (others => '0');
        h_jed <= (others => '0');
        m_des <= (others => '0');
        m_jed <= (others => '0');
        ah_des <= (others => '0');
        ah_jed <= (others => '0');
        am_des <= (others => '0');
        am_jed <= (others => '0');
        clk_1hz <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_display_driver of tb_display_driver is
    for tb
    end for;
end cfg_tb_display_driver;