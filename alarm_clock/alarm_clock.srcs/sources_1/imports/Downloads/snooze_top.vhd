-- Gemini written, with fixes
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity snooze_top is
    Port ( 
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        btnl         : in  STD_LOGIC;
        sig_comp_out : in  STD_LOGIC;
        clk1s        : in  STD_LOGIC;
        led16_r      : out STD_LOGIC
    );
end snooze_top;

architecture Structural of snooze_top is

    ----------------------------------------------------------------
    -- Internal Signal Declarations
    ----------------------------------------------------------------
    signal sig_press     : std_logic;
    signal sig_hold      : std_logic;
    signal sig_sqk_start : std_logic;
    signal sig_ti_start  : std_logic;
    signal sig_120       : std_logic;
    signal sig_300       : std_logic;
    signal sig_sqk       : std_logic;

    ----------------------------------------------------------------
    -- Component Declarations
    ----------------------------------------------------------------
    component debounce is
        Port ( clk : in STD_LOGIC; rst : in STD_LOGIC; btn_in : in STD_LOGIC;
               btn_state : out STD_LOGIC; btn_press : out STD_LOGIC;
               btn_hold : out STD_LOGIC; btn_release : out STD_LOGIC);
    end component;

    component rising_edge_detector is
        Port ( clk : in STD_LOGIC; rst : in STD_LOGIC; inpt : in STD_LOGIC;
               outpt : out STD_LOGIC);
    end component;

    component timer is
        generic ( G_SECONDS : natural );
        Port ( clk : in STD_LOGIC; rst : in STD_LOGIC; start : in STD_LOGIC;
               ce_1s : in STD_LOGIC; done : out STD_LOGIC);
    end component;

    component snooze is
        Port ( clk : in STD_LOGIC; rst : in STD_LOGIC; start : in STD_LOGIC;
               btn_hold : in STD_LOGIC; btn_press : in STD_LOGIC;
               timer_snooze_over : in STD_LOGIC; timer_no_response : in STD_LOGIC;
               squeak : out STD_LOGIC);
    end component;

begin

    -- Output Assignment
    led16_r <= sig_sqk;

    ----------------------------------------------------------------
    -- Component Instantiations
    ----------------------------------------------------------------

    -- Debounce logic for the button input
    U_DEBOUNCE : debounce
        port map (
            clk         => clk,
            rst         => rst,
            btn_in      => btnl,
            btn_state   => open,
            btn_press   => sig_press,
            btn_hold    => sig_hold,
            btn_release => open
        );

    -- Edge detector for the external comparator signal
    U_RE_DET_SQK : rising_edge_detector
        port map (
            clk   => clk,
            rst   => rst,
            inpt  => sig_comp_out,
            outpt => sig_sqk_start
        );

    -- Edge detector for the squeak feedback (loopback)
    U_RE_DET_TI : rising_edge_detector
        port map (
            clk   => clk,
            rst   => rst,
            inpt  => sig_sqk,
            outpt => sig_ti_start
        );

    -- Timer: 120 Second (No Response)
    U_TIMER_120 : timer
        generic map ( G_SECONDS => 120 )
        port map (
            clk   => clk,
            rst   => rst,
            start => sig_ti_start,
            ce_1s => clk1s,
            done  => sig_120
        );

    -- Timer: 300 Second (Snooze Over)
    U_TIMER_300 : timer
        generic map ( G_SECONDS => 300 )
        port map (
            clk   => clk,
            rst   => rst,
            start => sig_ti_start,
            ce_1s => clk1s,
            done  => sig_300
        );

    -- Main Snooze Control FSM
    U_SNOOZE : snooze
        port map (
            clk               => clk,
            rst               => rst,
            start             => sig_sqk_start,
            btn_hold          => sig_hold,
            btn_press         => sig_press,
            timer_snooze_over => sig_300,
            timer_no_response => sig_120,
            squeak            => sig_sqk
        );

end Structural;