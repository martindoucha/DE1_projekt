library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_time is
Generic ( G_BITS : positive := 4;
G_MAX  : positive := 5);  -- 5 for simulation, 100_000_000 for counting minutes)
  Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           cnthd : out STD_LOGIC_VECTOR (3 downto 0);
           cnthj : out STD_LOGIC_VECTOR (3 downto 0);
           cntmd : out STD_LOGIC_VECTOR (3 downto 0);
           cntmj : out STD_LOGIC_VECTOR (3 downto 0);
           btn_press : in std_logic;
           switch : in std_logic;
           switch2 : in std_logic);
end counter_time;

architecture Behavioral of counter_time is
    component clk_en is
        generic (G_MAX : positive);
        port (
            clk: in std_logic;
            rst: in std_logic;
            ce : out std_logic);
    end component clk_en;
    
    component countery_cas is
        generic ( G_BITS : positive);
        port (
            clk : in  std_logic;                             --! Main clock
            rst : in  std_logic;                             --! High-active synchronous reset
            en  : in  std_logic;                             --! Clock enable input
            en_button : in std_logic;
            switch : in std_logic;                         
            switch2 : in std_logic;
            cnt2hd : out std_logic_vector (G_BITS - 1 downto 0);
            cnt2hj : out std_logic_vector (G_BITS - 1 downto 0);
            cnt2md : out std_logic_vector (G_BITS - 1 downto 0);
            cnt2mj : out std_logic_vector (G_BITS - 1 downto 0));
    end component countery_cas;
    
        
    
    signal sig_cnthd : std_logic_vector (G_BITS - 1 downto 0);
    signal sig_cnthj : std_logic_vector (G_BITS - 1 downto 0);
    signal sig_cntmd : std_logic_vector (G_BITS - 1 downto 0);
    signal sig_cntmj : std_logic_vector (G_BITS - 1 downto 0);
    signal sig_onesec: std_logic ;
    signal sig_onemin: std_logic ;
    signal sec_counter: integer range 0 to 59 := 0;
    signal sig_btn_press: std_logic;
    signal sig_switch : std_logic;
    signal sig_switch2 : std_logic;
begin
    second_counter: clk_en
        generic map(G_MAX => G_MAX) 
        port map(
            clk => clk,
            rst => rst,
            ce  => sig_onesec
        );
    p_minute_maker : process(clk)
    begin
        if rising_edge(clk) then
            sig_onemin <= '0'; -- Default state: no pulse
            
            if rst = '1' then
                sec_counter <= 0;
            elsif sig_onesec = '1' then
                -- When we hit 59 seconds, roll back to 0 and fire the minute pulse!
                if sec_counter = 9 then
                    sec_counter <= 0;
                    sig_onemin <= '1'; 
                else
                    sec_counter <= sec_counter + 1;
                end if;
            end if;
        end if;
    end process p_minute_maker;
     
    countery_cas_0 : countery_cas
        generic map(G_BITS => G_BITS)
        port map(
            clk => clk,
            rst => rst,
            en  => sig_onemin,
            en_button => btn_press,
            switch => switch,
            switch2 => switch2,
            cnt2hd => sig_cnthd,
            cnt2hj => sig_cnthj,
            cnt2md => sig_cntmd,
            cnt2mj => sig_cntmj);
    cnthd <= sig_cnthd;
    cnthj <= sig_cnthj;
    cntmd <= sig_cntmd;
    cntmj <= sig_cntmj;     
    
 
end Behavioral;
