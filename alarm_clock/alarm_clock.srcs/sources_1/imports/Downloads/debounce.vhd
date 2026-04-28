--Parts of hold logic written by OpenAI's ChatGPT
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_state : out STD_LOGIC;
           btn_press : out STD_LOGIC;
           btn_hold : out STD_LOGIC;
           btn_release : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    ----------------------------------------------------------------
    -- Constants
    ----------------------------------------------------------------
    constant C_SHIFT_LEN : positive := 4;  -- Debounce history
    constant C_MAX       : positive := 200_000;  -- Sampling period
                                           -- 2 for simulation
                                           -- 200_000 (2 ms) for implementation !!!
    constant C_HOLD      : positive := 50_000_000;

    ----------------------------------------------------------------
    -- Internal signals
    ----------------------------------------------------------------
    signal ce_sample : std_logic;
    signal sync0     : std_logic;
    signal sync1     : std_logic;
    signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced : std_logic;
    signal delayed   : std_logic;
    signal hold_cnt : integer range 0 to C_HOLD := 0;
    signal btn_hold_int : std_logic := '0';
	signal hold_sent : std_logic := '0';

    ----------------------------------------------------------------
    -- Component declaration for clock enable
    ----------------------------------------------------------------
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;

begin
    ----------------------------------------------------------------
    -- Clock enable instance
    ----------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => C_MAX )
        port map (
            clk => clk,
            rst => rst,
            ce  => ce_sample
        );

    ----------------------------------------------------------------
    -- Synchronizer + debounce
    ----------------------------------------------------------------
    p_debounce : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sync0     <= '0';
                sync1     <= '0';
                shift_reg <= (others => '0');
                debounced <= '0';
                delayed   <= '0';

            else
                -- Input synchronizer
                sync1 <= sync0;
                sync0 <= btn_in;

                -- Sample only when enable pulse occurs
                if ce_sample = '1' then

                    -- Shift values to the left and load a new sample as LSB
                    shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                    -- Check if all bits are '1'
                    if shift_reg = (shift_reg'range => '1') then
                        debounced <= '1';
                    -- Check if all bits are '0'
                    elsif shift_reg = (shift_reg'range => '0') then
                        debounced <= '0';
                    end if;

                end if;
                
				-- Hold logic
				if debounced = '1' then
					if hold_cnt < C_HOLD then
						hold_cnt <= hold_cnt + 1;
					end if;
				else
					hold_cnt   <= 0;
					hold_sent  <= '0';
				end if;

				if (debounced = '1') and (hold_cnt = C_HOLD) and (hold_sent = '0') then
					btn_hold_int <= '1';
					hold_sent    <= '1';
				else
					btn_hold_int <= '0';
				end if;

                -- One clock delayed output for edge detector
                delayed <= debounced;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------
    btn_state <= debounced;

    -- One-clock pulse when button pressed
    btn_press   <= debounced and not(delayed);
    btn_release <= delayed and not(debounced);
    -- One-clock pulse when button held
    btn_hold    <= btn_hold_int;

end Behavioral;