library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity snooze is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           btn_hold : in STD_LOGIC;
           btn_press : in STD_LOGIC;
           timer_snooze_over : in STD_LOGIC;
           timer_no_response : in STD_LOGIC;
           squeak : out STD_LOGIC);
end snooze;

architecture Behavioral of snooze is
    type state_type is (IDLE, ACTIVE, SNOOZE);
    signal current_state : state_type := IDLE;
begin
    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                    current_state <= IDLE;
            else
                case current_state is
            
                    when IDLE =>
                        if start = '1' then
                            current_state <= ACTIVE;
                        else
                            current_state <= IDLE;
                        end if;
                    
                        squeak <= '0';
                    
                    when ACTIVE =>
                        if btn_press = '1' or timer_no_response = '1' then
                            current_state <= SNOOZE;
                        else
                            current_state <= ACTIVE;
                        end if;
                    
                        squeak <= '1';
    
                    when SNOOZE =>
                        if timer_snooze_over = '1' then
                            current_state <= ACTIVE;
                        elsif btn_hold = '1' then
                            current_state <= IDLE;
                        else
                            current_state <= SNOOZE;
                        end if;
                    
                        squeak <= '0';
                    
                end case;

            end if;
        end if;
    end process;

end Behavioral;
