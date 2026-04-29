library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_en is
    generic(
        G_MAX : positive := 5 -- Default value
    );
    Port ( clk   : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           ce    : out STD_LOGIC;
           f_out : out STD_LOGIC -- PŘIDANÝ PORT PRO BLIKÁNÍ
    );
end clk_en;

architecture Behavioral of clk_en is
    signal s_cnt   : integer range 0 to G_MAX-1;
    signal s_f_out : std_logic := '0'; -- Vnitřní signál pro překlápění
begin

    -- Průběžné přiřazení vnitřního stavu na výstupní port
    f_out <= s_f_out;

    -- Count clock pulses and generate a one-clock-cycle enable pulse
    process (clk) is
    begin
        if rising_edge(clk) then  -- Synchronous process
            if rst = '1' then     -- High-active reset
                ce      <= '0';   -- Reset output
                s_cnt   <= 0;     -- Reset internal counter
                s_f_out <= '0';   -- Reset blikání

            elsif s_cnt = G_MAX-1 then
                ce      <= '1';
                s_cnt   <= 0;
                s_f_out <= not s_f_out; -- Překlopení stavu f_out
                
            else
                ce      <= '0';
                s_cnt   <= s_cnt + 1;
                
            end if;  -- End if for reset/check
        end if;      -- End if for rising_edge
    end process;

end Behavioral;
