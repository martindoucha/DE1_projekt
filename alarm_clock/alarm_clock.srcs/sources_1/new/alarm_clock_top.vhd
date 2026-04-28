library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alarm_clock_top is
    Port ( clk : in STD_LOGIC;
           btnc : in STD_LOGIC; -- reset
           btnl : in STD_LOGIC; -- stop alarm
           placeholder1 : in STD_LOGIC;
           placeholder2 : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           dp : out STD_LOGIC;
           led16_r : out STD_LOGIC); --signalization of alarm
end alarm_clock_top;

architecture Behavioral of alarm_clock_top is

begin


end Behavioral;
