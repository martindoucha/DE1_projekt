-- ChatGPT wrote this :)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    generic (
        G_SECONDS : natural := 120  -- Target time (e.g., 120 or 300)
    );
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        start : in  STD_LOGIC;
        ce_1s : in  STD_LOGIC;  -- 1 Hz clock enable
        done  : out STD_LOGIC   -- single pulse when time expires
    );
end timer;

architecture Behavioral of timer is
    signal counter : natural range 0 to G_SECONDS := 0;
    signal active  : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= 0;
                active  <= '0';
                done    <= '0';

            else
                done <= '0'; -- default (pulse behavior)

                -- Start timer
                if start = '1' then
                    active  <= '1';
                    counter <= 0;
                end if;

                -- Count seconds only when enabled
                if active = '1' and ce_1s = '1' then
                    if counter = G_SECONDS - 1 then
                        done    <= '1';  -- one-cycle pulse
                        active  <= '0';  -- stop after pulse
                    else
                        counter <= counter + 1;
                    end if;
                end if;

            end if;
        end if;
    end process;

end Behavioral;