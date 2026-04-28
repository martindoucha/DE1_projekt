library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Kód byl vygenerován s pomocí LLM Gemini

entity alarm_clock_top is
    Port ( 
        clk     : in  STD_LOGIC; -- 100 MHz hlavní hodiny (Pin E3)
        btnc    : in  STD_LOGIC; -- Reset celého systému (Pin N17)
        btnl    : in  STD_LOGIC; -- Tlačítko Snooze / Zrušit (Pin P17)
        
        -- Fyzické výstupy na 7-segmentový displej
        seg     : out STD_LOGIC_VECTOR (6 downto 0);
        an      : out STD_LOGIC_VECTOR (7 downto 0);
        dp      : out STD_LOGIC;
        
        -- Výstup pro signalizaci alarmu
        led16_r : out STD_LOGIC  -- Červená LED (Pin N15)
    );
end alarm_clock_top;

architecture Behavioral of alarm_clock_top is

    ----------------------------------------------------------------
    -- Vnitřní propojovací signály
    ----------------------------------------------------------------
    
    -- Signály aktuálního času (výstupy z counter_auto)
    signal sig_h_des, sig_h_jed : std_logic_vector(3 downto 0);
    signal sig_m_des, sig_m_jed : std_logic_vector(3 downto 0);
    
    -- Signály nastaveného alarmu (fixně 06:00)
    -- Lze je v budoucnu nahradit výstupy z dalších čítačů pro nastavování.
    signal alrm_h_des : std_logic_vector(3 downto 0) := x"0";
    signal alrm_h_jed : std_logic_vector(3 downto 0) := x"6";
    signal alrm_m_des : std_logic_vector(3 downto 0) := x"0";
    signal alrm_m_jed : std_logic_vector(3 downto 0) := x"0";

    -- Řídicí signály pro timery a blikání
    signal sig_ce_1s     : std_logic; -- Puls každou 1 vteřinu (pro Snooze timery)
    signal sig_f_out_1hz : std_logic; -- Překlápí se každou 0.5s (pro blikání tečky)
    
    -- Výstup z komparátoru (1 = čas se shoduje s budíkem)
    signal sig_comp_out  : std_logic; 

begin

    --------------------------------------------------------
    -- 1. Generátor 1s pulsu (Pro Snooze Timery)
    --------------------------------------------------------
    clk_gen_1s_pulse : entity work.clk_en
        generic map( G_MAX => 100_000_000 ) -- 1 sekunda
        port map(
            clk   => clk,
            rst   => btnc,
            ce    => sig_ce_1s,
            f_out => open
        );

    --------------------------------------------------------
    -- 2. Generátor 1Hz blikání (Pro displej - dvojtečka)
    --------------------------------------------------------
    clk_gen_blink : entity work.clk_en
        generic map( G_MAX => 50_000_000 ) -- 0.5 sekundy
        port map(
            clk   => clk,
            rst   => btnc,
            ce    => open,
            f_out => sig_f_out_1hz
        );

    --------------------------------------------------------
    -- 3. Hlavní kaskáda čítačů (Generuje aktuální čas)
    -- Uvnitř má svůj vlastní clk_en pro vteřinový takt.
    --------------------------------------------------------
    time_counters : entity work.counter_auto
        generic map( 
            G_BITS => 4,
            G_MAX  => 100_000_000 -- Interval pro reálný chod (1 s)
        )
        port map(
            clk   => clk,
            rst   => btnc,
            cnthd => sig_h_des,
            cnthj => sig_h_jed,
            cntmd => sig_m_des,
            cntmj => sig_m_jed
        );

    --------------------------------------------------------
    -- 4. Komparátor (Porovnává čas a alarm)
    --------------------------------------------------------
    comparator_inst : entity work.comparator
        port map(
            clk    => clk,
            rst    => btnc,
            nas_hd => alrm_h_des,
            nas_hj => alrm_h_jed,
            nas_md => alrm_m_des,
            nas_mj => alrm_m_jed,
            akt_hd => sig_h_des,
            akt_hj => sig_h_jed,
            akt_md => sig_m_des,
            akt_mj => sig_m_jed,
            outpt  => sig_comp_out
        );

    --------------------------------------------------------
    -- 5. Snooze Modul (Logika buzení, Timery a Debounce)
    --------------------------------------------------------
    snooze_subsystem : entity work.snooze_top
        port map(
            clk          => clk,
            rst          => btnc,
            btnl         => btnl,         -- Signál přímo z pinu FPGA
            sig_comp_out => sig_comp_out, -- Spouštěč od komparátoru
            clk1s        => sig_ce_1s,    -- Takt pro 120s a 300s timery
            led16_r      => led16_r       -- Signalizace budíku na LED
        );

    --------------------------------------------------------
    -- 6. Displej Driver (Kreslí data na 7-segment)
    --------------------------------------------------------
    display_inst : entity work.display_driver
        port map(
            clk     => clk,
            rst     => btnc,
            -- Aktuální čas (pravá strana displeje)
            h_des   => sig_h_des,
            h_jed   => sig_h_jed,
            m_des   => sig_m_des,
            m_jed   => sig_m_jed,
            -- Nastavený budík (levá strana displeje)
            ah_des  => alrm_h_des,
            ah_jed  => alrm_h_jed,
            am_des  => alrm_m_des,
            am_jed  => alrm_m_jed,
            -- Takt pro blikání dvojtečky (0.5s)
            clk_1hz => sig_f_out_1hz,
            -- Propojení na fyzické piny
            seg     => seg,
            an      => an,
            dp      => dp
        );

end Behavioral;
