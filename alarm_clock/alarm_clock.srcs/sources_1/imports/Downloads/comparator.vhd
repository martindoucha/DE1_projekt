-- Google Gemini written
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           nas_hd : in STD_LOGIC_VECTOR(3 downto 0);
           nas_hj : in STD_LOGIC_VECTOR(3 downto 0);
           nas_md : in STD_LOGIC_VECTOR(3 downto 0);
           nas_mj : in STD_LOGIC_VECTOR(3 downto 0);
           akt_hd : in STD_LOGIC_VECTOR(3 downto 0);
           akt_hj : in STD_LOGIC_VECTOR(3 downto 0);
           akt_md : in STD_LOGIC_VECTOR(3 downto 0);
           akt_mj : in STD_LOGIC_VECTOR(3 downto 0);
           outpt  : out STD_LOGIC );
end comparator;

architecture Behavioral of comparator is
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                outpt <= '0';
            else
                -- Check if 'nas' (Set Time) matches 'akt' (Actual/Current Time)
                if (nas_hd = akt_hd) and 
                   (nas_hj = akt_hj) and 
                   (nas_md = akt_md) and 
                   (nas_mj = akt_mj) then
                    
                    outpt <= '1';
                else
                    outpt <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;