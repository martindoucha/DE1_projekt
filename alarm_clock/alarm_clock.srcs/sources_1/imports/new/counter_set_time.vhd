library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- Package for data types conversion

-------------------------------------------------

entity counter_set_time is
    generic (
        G_BITS : positive := 4  --! Default number of bits
    );
    port (
        clk : in  std_logic;                             --! Main clock
        rst : in  std_logic;                             --! High-active synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        cnt2hd : out std_logic_vector (G_BITS - 1 downto 0);
        cnt2hj : out std_logic_vector (G_BITS - 1 downto 0);
        cnt2md : out std_logic_vector (G_BITS - 1 downto 0);
        cnt2mj : out std_logic_vector (G_BITS - 1 downto 0);
        switch :  in std_logic 
    );
end entity counter_set_time;

-------------------------------------------------

architecture behavioral of counter_set_time is
    
    constant HD_MAX: integer := 2;
    constant HJ_MAX: integer := 9;
    constant MD_MAX: integer := 5;
    constant MJ_MAX: integer := 9;
    
    signal sig_cnt2hd : integer range 0 to HD_MAX;
    signal sig_cnt2hj : integer range 0 to HJ_MAX;
    signal sig_cnt2md : integer range 0 to MD_MAX;
    signal sig_cnt2mj : integer range 0 to MJ_MAX;
begin

    --! Clocked process with synchronous reset which implements
    --! N-bit up counter.

    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then    -- Synchronous, active-high reset
                sig_cnt2hd <= 0;
                sig_cnt2hj <= 0;
                sig_cnt2md <= 0;
                sig_cnt2mj <= 0;

            elsif en = '1' then  -- Clock enable activated
                if switch = '0' then
                 if sig_cnt2hd=2 AND sig_cnt2hj=3 then
                    sig_cnt2hd <= 0;
                    sig_cnt2hj <= 0;
                  
                 
                 elsif sig_cnt2hj = HJ_MAX then 
                            sig_cnt2hj <= 0;
                            sig_cnt2hd <= sig_cnt2hd + 1;
                 else
                            sig_cnt2hj <= sig_cnt2hj +1;
                 end if;
                
                end if;
                if switch = '1' then
                    if sig_cnt2md=5 AND sig_cnt2mj=9 then
                        sig_cnt2md <= 0;
                        sig_cnt2mj <= 0;
                    
                    elsif sig_cnt2mj = MJ_MAX then 
                            sig_cnt2mj <= 0;
                            sig_cnt2md <= sig_cnt2md + 1;
                    else
                            sig_cnt2mj <= sig_cnt2mj +1;
                 end if;
                end if;                       
            end if;
        end if;
        
   end process p_counter;

    -- Convert integer to std_logic_vector
    cnt2hd <= std_logic_vector(to_unsigned(sig_cnt2hd, G_BITS));
    cnt2hj <= std_logic_vector(to_unsigned(sig_cnt2hj, G_BITS));
    cnt2md <= std_logic_vector(to_unsigned(sig_cnt2md, G_BITS));
    cnt2mj <= std_logic_vector(to_unsigned(sig_cnt2mj, G_BITS));

end architecture behavioral;