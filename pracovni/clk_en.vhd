library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_en is
    generic(
        G_MAX : positive := 5
    );
    Port ( clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           ce    : out STD_LOGIC; -- Krátký puls (jeden takt clk)
           f_out : out STD_LOGIC  -- Obdélníkový signál (pro blikání)
    );
end clk_en;

architecture Behavioral of clk_en is
    signal s_cnt : integer range 0 to G_MAX-1;
    signal s_f_out : std_logic := '0';
begin

    f_out <= s_f_out;

    process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ce      <= '0';
                s_cnt   <= 0;
                s_f_out <= '0';

            elsif s_cnt = G_MAX-1 then
                ce    <= '1';
                s_cnt <= 0;
                
                s_f_out <= not s_f_out; 
                
            else
                ce    <= '0';
                s_cnt <= s_cnt + 1;
                
            end if;
        end if;
    end process;

end Behavioral;
