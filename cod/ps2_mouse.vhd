----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2020 09:17:11 PM
-- Design Name: 
-- Module Name: ps2_mouse - Behavioral
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

entity ps2_mouse is
  Port ( 
    clk: in std_logic;
    rst: in std_logic;
    ps2_clk:    inout std_logic;
    ps2_data:   inout std_logic;
    mouseData: out std_logic_vector(23 downto 0); --3 octeti de informatie
    mouse_done: out std_logic
  );
end ps2_mouse;

architecture Behavioral of ps2_mouse is
type stare is (reset, init1, init2, init3, first, second, third,done);
signal state: stare;

signal tx_data,rx_data: std_logic_vector(7 downto 0);
signal tx_en,rx_en: std_logic;
signal tx_busy, tx_done,rx_done,rx_error: std_logic;
signal prev : std_logic;

begin

rxtx: entity WORK.ps2Interface port map(
    clk=>clk,
    rst=>rst,
    tx_data=>tx_data,
    rx_data=>rx_data,
            
    tx_en=>tx_en, 
    rx_en=>rx_en,  
            
    ps2_clk=>ps2_clk,
    ps2_data=>ps2_data,
            
    tx_busy=>tx_busy,
    tx_done=>tx_done,
            
    rx_done=>rx_done,
    rx_error=>rx_error
);

process(clk, rst)
begin
    if rst='1' then
     
      mouseData<=(others=>'0');
            
      state<=reset;
    else
        if rising_edge(clk) then
            prev <= rx_done;
            
            case state is
                when reset =>
                    state<=init1;
                    
                 when init1 =>
                    
                    tx_data<="11110100"; --F4 comanda de stream
                    
                    state<=init2;
                    
                 when init2 =>
                    --asteptam transmisiunea
                    if tx_done='1' then 
                        state<=init3;
                        rx_en<='1';
                    end if;
                    
                 when init3 =>
                    --primim raspuns
                    if rx_done='1' then
                        state<=first;
                    end if;
                    
                  when first =>
                    --primul octet
                    if rx_done='1' then
                        mouseData(7 downto 0) <=rx_data;
                        state<=second;
                        
                     end if;
                     
                  when second =>
                    if rx_done='1' then
                        mouseData(15 downto 8) <=rx_data;
                        state<=third;
                    end if;
                    
                   when third =>
                   
                    if rx_done='1' then
                        mouseData(23 downto 16) <=rx_data;
                        state<=done;
                    end if;
                    
                  when done =>
                    state<=first;
                    
            end case;
        end if;   
    end if;
end process;

mouse_done<='1' when state=done else '0';
tx_en<='1' when state=init1 else '0';
end Behavioral;
