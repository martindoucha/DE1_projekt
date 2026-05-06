-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 19 Apr 2026 10:30:20 GMT
-- Request id : cfwk-fed377c2-69e4aebc0ac12

library ieee;
use ieee.std_logic_1164.all;

entity tb_counter_time is
end tb_counter_time;

architecture tb of tb_counter_time is
    constant c_G_BITS : positive := 4;
    constant c_G_MAX : positive := 5;
    
    component counter_time
     generic (
            G_BITS : positive;
            G_MAX : positive
        );
        port (clk   : in std_logic;
              rst   : in std_logic;
              cnthd : out std_logic_vector (3 downto 0);
              cnthj : out std_logic_vector (3 downto 0);
              cntmd : out std_logic_vector (3 downto 0);
              cntmj : out std_logic_vector (3 downto 0);
              btn_press : in std_logic;
              switch : in std_logic;
              switch2 : in std_logic);
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal cnthd : std_logic_vector (3 downto 0);
    signal cnthj : std_logic_vector (3 downto 0);
    signal cntmd : std_logic_vector (3 downto 0);
    signal cntmj : std_logic_vector (3 downto 0);
    signal btn_press   : std_logic;
    signal switch   : std_logic;
    signal switch2   : std_logic;
    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter_time
    generic map (
        G_BITS => c_G_BITS,
        G_MAX => c_G_MAX
    )
    port map (clk   => clk,
              rst   => rst,
              cnthd => cnthd,
              cnthj => cnthj,
              cntmd => cntmd,
              cntmj => cntmj,
              btn_press => btn_press,
              switch => switch,
              switch2 => switch2
              );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        switch2 <= '0';
        wait for 1000 ns;
        switch2<='1';
        switch<='0';
        btn_press<='1';
        wait for 200ns;
        btn_press<='0';
        wait for 100ns;
        btn_press<='1';
        switch<='1';
        wait for 200ns;
        
        
        
        
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter_time of tb_counter_time is
    for tb
    end for;
end cfg_tb_counter_time;