----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2020 07:33:35 PM
-- Design Name: 
-- Module Name: ps2_rx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2_rx is

 generic (
        clkFreq: integer:= 100_000_000
    );
    
Port (
    clk:        in std_logic;
    rst:        in std_logic;
    ps2_clk:    inout std_logic;
    ps2_data:   inout std_logic;
    
    rx_en:      in std_logic;
    rx_data:    out std_logic_vector(7 downto 0);
    rx_done:    out std_logic;
    rx_error:   out std_logic
 );
end ps2_rx;

architecture Behavioral of ps2_rx is

type stare is (idle, start, data, stop);
signal state: stare;
signal countTime:integer:=0;
signal countBits: integer:=0;
constant freq: integer:= 10_000_000;
constant rate: integer:= clkFreq/freq;
signal clkPrev : std_logic;

signal ps2_word: std_logic_vector(10 downto 0):=x"00"&"000"; --initializam cu 11 biti de 0
signal parity: std_logic;

signal triClk, triData: std_logic; --pentru bufferele tri-state
signal ps2_c, ps2_d: std_logic;
signal error: std_logic;

signal syncClk, syncData: std_logic;
signal debouncedClk, debouncedData: std_logic;

begin


--sincronizam
process(clk)
begin
    if rising_edge(clk) then
        syncClk<=ps2_clk;
        syncData<=ps2_data;
    end if;
end process;

--trecem prin debounce semnalele
debouncePS2_clk: entity WORK.debounce port map(
    clk =>clk,
    rst => rst,
    din => syncClk,
    qout =>debouncedClk
);

debouncePS2_data: entity WORK.debounce port map(
    clk =>clk,
    rst => rst,
    din => syncData,
    qout =>debouncedData
);

--FSM pentru transmisie
process(clk, rst)
begin
    if rst='1' then

        rx_data <= (others=>'0');
        rx_done <= '0';
        rx_error <= '0';
        
        triClk <= '0';
        triData <= '0';
        
        countTime<=0;
        countBits<=0;
        
       
        state <= idle;
    else
        if rising_edge(clk) then
            clkPrev <= debouncedClk;
            
            case state is
            
                when idle =>
                
                    --initializari
                    rx_data <= (others=>'0');
                    rx_done <= '0';
                    rx_error <= '0';
                    
                    triClk <= '0';
                    triData <= '0';
                    
                    countTime<=0;
                    countBits<=0;
                    
                    ps2_c <='1'; --inactiv
                    ps2_d <='1';
                   
                    state<=start;
                    
                
                when start =>
                    --nu au trecut 100us
                    if countTime < rate then
                        countTime <= countTime +1;
                        state<=start;
                    else
                        if rx_en='1' then
                       
                            --citire pe falling edge bit de start
                            if clkPrev='1' and debouncedClk='0'  then
                                ps2_word <= debouncedData & ps2_word(10 downto 1);
                                countBits <= countBits+1;
                                state<=data;
                            end if;
                            
                        end if;
                    end if;
                    
                    
                    
                  when data =>
                    if rx_en='1' then
                        if clkPrev='1' and debouncedClk='0'  then
                            ps2_word <= debouncedData & ps2_word(10 downto 1);
                            countBits <= countBits+1;
                            
                            if countBits=11 then
                                state<=stop;
                            else
                                 state<=data;
                            end if;
                            
                        end if;
                    end if;
                    
                  when stop =>
                        
                        state<=start;
                
            end case;
            
        end if;
    end if;
end process;

error <= NOT (NOT ps2_word(0) AND ps2_word(10) AND (ps2_word(9) XOR ps2_word(8) XOR
				ps2_word(7) XOR ps2_word(6) XOR ps2_word(5) XOR ps2_word(4) XOR ps2_word(3) XOR 
				ps2_word(2) XOR ps2_word(1)));


rx_data<=ps2_word(8 downto 1);

ps2_clk <= ps2_c when triClk ='1' else '0'; --sau Z in else
ps2_data <= ps2_d when triData ='1' else '0';

triClk <= '1' when state=start else '0';
triData <='1' when state=start else '0';

ps2_c <= '0' when state=start else '1';
ps2_d <= '0' when state=start else --bitul de start e mereu 0
         ps2_word(0) when state=data else
         '1';
         
rx_done<='1' when error='0' and state=stop else '0';
rx_error<=error when state=stop else '0';
 
end Behavioral;
