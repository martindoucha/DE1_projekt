library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--kód byl generován s pomocí LLM Gemini

entity display_driver is
    Port (
        clk      : in  STD_LOGIC; -- 100 MHz z desky
        rst      : in  STD_LOGIC; -- Synchronní reset
        -- Vstupy dat (ČAS)
        h_des    : in  STD_LOGIC_VECTOR (3 downto 0);
        h_jed    : in  STD_LOGIC_VECTOR (3 downto 0);
        m_des    : in  STD_LOGIC_VECTOR (3 downto 0);
        m_jed    : in  STD_LOGIC_VECTOR (3 downto 0);
        -- Vstupy dat (ALARM)
        ah_des   : in  STD_LOGIC_VECTOR (3 downto 0);
        ah_jed   : in  STD_LOGIC_VECTOR (3 downto 0);
        am_des   : in  STD_LOGIC_VECTOR (3 downto 0);
        am_jed   : in  STD_LOGIC_VECTOR (3 downto 0);
        -- Signál pro dvojtečku (přichází z f_out druhého clk_en v top levelu)
        clk_1hz  : in  STD_LOGIC;
        -- Fyzické výstupy na displej
        seg      : out STD_LOGIC_VECTOR (6 downto 0);
        an       : out STD_LOGIC_VECTOR (7 downto 0);
        dp       : out STD_LOGIC
    );
end display_driver;

architecture Behavioral of display_driver is

    -- Vnitřní signály pro propojení sub-komponent
    signal sig_ce_refresh : std_logic;
    signal sig_cnt_3bit   : std_logic_vector(2 downto 0);
    signal sig_bin_to_dec : std_logic_vector(3 downto 0);

begin

    --------------------------------------------------------
    -- 1. Generování obnovovacího pulsu (Refresh Rate)
    -- G_MAX = 100 000 (pro 100 MHz clock -> 1 kHz puls)
    -- Pro simulaci necháváme 10, pro desku změň na 100000
    --------------------------------------------------------
    clk_en_inst : entity work.clk_en
        generic map( G_MAX => 10 ) 
        port map(
            clk   => clk,
            rst   => rst,
            ce    => sig_ce_refresh,
            f_out => open  -- Zde f_out nepotřebujeme, zůstává nezapojen
        );

    --------------------------------------------------------
    -- 2. Čítač pozice displeje (0 až 7)
    --------------------------------------------------------
    counter_inst : entity work.counter
        generic map( G_BITS => 3 )
        port map(
            clk => clk,
            rst => rst,
            en  => sig_ce_refresh,
            cnt => sig_cnt_3bit
        );

    --------------------------------------------------------
    -- 3. Dekodér binárních dat na segmenty
    --------------------------------------------------------
    bin2seg_inst : entity work.bin2seg
        port map(
            bin => sig_bin_to_dec,
            seg => seg
        );

    --------------------------------------------------------
    -- 4. Multiplexer: Výběr dat, anody a dvojtečky
    --------------------------------------------------------
    p_mux : process(sig_cnt_3bit, h_des, h_jed, m_des, m_jed, ah_des, ah_jed, am_des, am_jed, clk_1hz)
    begin
        case sig_cnt_3bit is
            -- ČAS (pozice 0-3)
            when "000" => 
                an <= "11111110"; sig_bin_to_dec <= m_jed; dp <= '1';
            when "001" => 
                an <= "11111101"; sig_bin_to_dec <= m_des; dp <= '1';
            when "010" => -- Mezi hodinami a minutami bliká dvojtečka
                an <= "11111011"; sig_bin_to_dec <= h_jed; dp <= not clk_1hz; 
            when "011" => 
                an <= "11110111"; sig_bin_to_dec <= h_des; dp <= '1';

            -- ALARM (pozice 4-7)
            when "100" => 
                an <= "11101111"; sig_bin_to_dec <= am_jed; dp <= '1';
            when "101" => 
                an <= "11011111"; sig_bin_to_dec <= am_des; dp <= '1';
            when "110" => -- U alarmu může dvojtečka svítit trvale pro odlišení
                an <= "10111111"; sig_bin_to_dec <= ah_jed; dp <= '0';
            when "111" => 
                an <= "01111111"; sig_bin_to_dec <= ah_des; dp <= '1';
            
            when others =>
                an <= "11111111"; sig_bin_to_dec <= x"0"; dp <= '1';
        end case;
    end process p_mux;

end Behavioral;
