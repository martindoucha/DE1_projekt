-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 06 May 2026 08:45:19 GMT
-- Request id : cfwk-fed377c2-69faff9f3d21c

library ieee;
use ieee.std_logic_1164.all;

entity tb_snooze is
end tb_snooze;

architecture tb of tb_snooze is

    component snooze
        port (clk               : in std_logic;
              rst               : in std_logic;
              start             : in std_logic;
              btn_hold          : in std_logic;
              btn_press         : in std_logic;
              timer_snooze_over : in std_logic;
              timer_no_response : in std_logic;
              squeak            : out std_logic);
    end component;

    signal clk               : std_logic;
    signal rst               : std_logic;
    signal start             : std_logic;
    signal btn_hold          : std_logic;
    signal btn_press         : std_logic;
    signal timer_snooze_over : std_logic;
    signal timer_no_response : std_logic;
    signal squeak            : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : snooze
    port map (clk               => clk,
              rst               => rst,
              start             => start,
              btn_hold          => btn_hold,
              btn_press         => btn_press,
              timer_snooze_over => timer_snooze_over,
              timer_no_response => timer_no_response,
              squeak            => squeak);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        start <= '0';
        btn_hold <= '0';
        btn_press <= '0';
        timer_snooze_over <= '0';
        timer_no_response <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        -- ***EDIT*** Add stimuli here
        start <= '1';
	wait for 10 ns;
	start <= '0';
        wait for 40 ns;
	timer_no_response <= '1';
	wait for 10 ns;
	timer_no_response <= '0';
	wait for 40 ns;
	timer_snooze_over <= '1';
	wait for 10 ns;
	timer_snooze_over <= '0';
	wait for 40 ns;
	btn_hold <= '1';
	wait for 10 ns;
	btn_hold <= '0';
	wait for 40 ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_snooze of tb_snooze is
    for tb
    end for;
end cfg_tb_snooze;