library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rising_edge_detector is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           inpt : in STD_LOGIC;
           outpt : out STD_LOGIC);
end rising_edge_detector;

architecture Behavioral of rising_edge_detector is

    signal sig_last : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                outpt <= '0';
                sig_last <= '0';
            else
            
                if inpt = '1' and sig_last = '0' then
                    outpt <= '1';
                else
                    outpt <= '0';
                end if;
                sig_last <= inpt;
                
            end if;
        end if;
    end process;

end Behavioral;