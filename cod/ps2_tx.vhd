----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2020 04:24:32 PM
-- Design Name: 
-- Module Name: ps2_tx - Behavioral
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

entity ps2_tx is
    generic (
        clkFreq: integer:= 100_000_000
    );
 Port (
    clk:    in std_logic;
    rst:    in std_logic;
    --pentru transmisie 7 sau 8 biti
    tx_data: in std_logic_vector(7 downto 0); --8 biti de comanda de transmit
    tx_en:   in std_logic; --se poate transmite
    ps2_clk: inout std_logic;
    ps2_data: inout std_logic;
    tx_busy: out std_logic; --transmisie in progres
    tx_done: out std_logic --s-a terminat transmisia
    
 );
end ps2_tx;

architecture Behavioral of ps2_tx is
type stare is (requestToSend, start, data, stop);
signal state: stare;
signal ps2_word: std_logic_vector(10 downto 0):=x"00"&"000"; --initializam cu 11biti de 0
signal parity: std_logic;

signal triClk, triData: std_logic; --pentru bufferele tri-state
signal ps2_c, ps2_d: std_logic;
signal countTime:integer:=0;
signal countBits: integer:=0;
constant freq: integer:= 10_000_000;
constant rate: integer:= clkFreq/freq;
signal clkPrev : std_logic;

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

--calculare bit de paritate
parity <= not (tx_data(7) xor tx_data(6) xor tx_data(5) xor tx_data(4) xor tx_data(3) xor tx_data(2) xor tx_data(1) xor tx_data(0));



--FSM pentru transmisie
process(clk, rst)
begin
    if rst='1' then
           
        tx_busy <= '0'; --nu e nicio transmisie in progres
       
        triClk <= '0';
        triData <= '0';
        
        countTime<=0;
        countBits<=0;
        
      
        
        state <= requestToSend;
    else
        if rising_edge(clk) then
            clkPrev <= debouncedClk;
            case state is
                when requestToSend =>
                
                    countTime<=0;
                    countBits<=0;
                    
                   --se transmite daca tx_en=1
                   if tx_en='1' then
                        --se transmite FF, adica e pregatit sa receptioneze de la mouse
                        tx_busy <= '1';                 
                        --stop + parity + data(7 downto 0) + start
                        ps2_word <= '1' & parity & tx_data & '0';

                        state<=start;
                   end if;
                   
                when start =>
                --asteptam 100 us si trimitem bitul de start
                if countTime < rate then
                    countTime <= countTime +1;
                    
                    state<=start;
                else
                    --safe zone
                    --ps2_d <= ps2_word(0);
                    countBits <= countBits+1;
                    if clkPrev='1' and debouncedClk='0' then
                        state <= data;
                    end if;
                end if;
                
              when data =>
                --shiftarea se face pe falling edge(adica cineva citeste)
                if clkPrev='1' and debouncedClk='0' then
                    ps2_word <= '0' & ps2_word(10 downto 1);
                    countBits <= countBits+1;
                    
                     if countBits=11 then
                        state<=stop;
                    else 
                        state <= data;
                    end if;
                end if; 
               
              
              when stop =>
               if clkPrev='1' and debouncedClk='0' then
                    state<=requestToSend;
                end if;
                 
            end case;
        end if;
    end if;
end process;

--pentru buffere
ps2_clk <= ps2_c when triClk ='1' else '0'; --sau Z in else
ps2_data <= ps2_d when triData ='1' else '0';

--request to send by pulling clock line low
ps2_c <= '0' when state=requestToSend else '1';
ps2_d <= '0' when state=start else --bitul de start e mereu 0
         ps2_word(0) when state=data else
         '1';

triClk <= '1' when state=requestToSend or state=start else '0';
triData <='1' when state=start else '0';
        
tx_done <='1' when state=stop else '0';

end Behavioral;
