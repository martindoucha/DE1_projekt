-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 04 May 2026 13:31:35 GMT
-- Request id : cfwk-fed377c2-69f89fb7e3a8f

library ieee;
use ieee.std_logic_1164.all;

entity tb_comparator is
end tb_comparator;

architecture tb of tb_comparator is

    component comparator
        port (clk    : in std_logic;
              rst    : in std_logic;
              nas_hd : in std_logic_vector (3 downto 0);
              nas_hj : in std_logic_vector (3 downto 0);
              nas_md : in std_logic_vector (3 downto 0);
              nas_mj : in std_logic_vector (3 downto 0);
              akt_hd : in std_logic_vector (3 downto 0);
              akt_hj : in std_logic_vector (3 downto 0);
              akt_md : in std_logic_vector (3 downto 0);
              akt_mj : in std_logic_vector (3 downto 0);
              outpt  : out std_logic);
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal nas_hd : std_logic_vector (3 downto 0);
    signal nas_hj : std_logic_vector (3 downto 0);
    signal nas_md : std_logic_vector (3 downto 0);
    signal nas_mj : std_logic_vector (3 downto 0);
    signal akt_hd : std_logic_vector (3 downto 0);
    signal akt_hj : std_logic_vector (3 downto 0);
    signal akt_md : std_logic_vector (3 downto 0);
    signal akt_mj : std_logic_vector (3 downto 0);
    signal outpt  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : comparator
    port map (clk    => clk,
              rst    => rst,
              nas_hd => nas_hd,
              nas_hj => nas_hj,
              nas_md => nas_md,
              nas_mj => nas_mj,
              akt_hd => akt_hd,
              akt_hj => akt_hj,
              akt_md => akt_md,
              akt_mj => akt_mj,
              outpt  => outpt);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        nas_hd <= (others => '0');
        nas_hj <= (others => '0');
        nas_md <= (others => '0');
        nas_mj <= (others => '0');
        akt_hd <= (others => '0');
        akt_hj <= (others => '0');
        akt_md <= (others => '0');
        akt_mj <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        
        nas_hd <= '0000';
        nas_hj <= '0100';
        nas_md <= '0011';
        nas_mj <= '0000'; -- 8:30
        
        akt_hd <= '0000';
        akt_hj <= '0100';
        akt_md <= '0010';
        akt_mj <= '1000'; -- 8:28
        wait for 100 ns; --wait 10 clk cycles
        
        akt_hd <= '0000';
        akt_hj <= '0100';
        akt_md <= '0010';
        akt_mj <= '1001'; -- 8:29
        wait for 100 ns;

        akt_hd <= '0000';
        akt_hj <= '0100';
        akt_md <= '0011';
        akt_mj <= '0000'; -- 8:30
        wait for 100 ns;
        
        akt_hd <= '0000';
        akt_hj <= '0100';
        akt_md <= '0011';
        akt_mj <= '0001'; -- 8:31
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_comparator of tb_comparator is
    for tb
    end for;
end cfg_tb_comparator;