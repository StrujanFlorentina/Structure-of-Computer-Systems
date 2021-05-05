----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/09/2021 09:13:07 PM
-- Design Name: 
-- Module Name: mouse_tb - Behavioral
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

entity mouse_tb is
--  Port ( );
end mouse_tb;

architecture Behavioral of mouse_tb is
signal clk: std_logic;
signal rst: std_logic;
signal tx_data: std_logic_vector(7 downto 0);
signal rx_data: std_logic_vector(7 downto 0);
         
signal tx_en: std_logic;
signal rx_en: std_logic;
         
signal ps2_clk: std_logic;
signal ps2_data:std_logic;
         
signal tx_busy: std_logic;
signal tx_done: std_logic;
         
signal rx_done: std_logic;
signal rx_error:std_logic;


constant clk_period: time:= 20 ns;
begin

DUT: entity WORK.ps2Interface port map(
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

clkProc: process
begin
    clk<='0';
    wait for clk_period/2;
    clk<='1';
    wait for clk_period/2;
end process;

sim:process
begin
    rst<='1';
    wait for clk_period/2;
    rst<='0';
    
    tx_data<="11110100"; --comanda de stream
    tx_en<='1';
    rx_en<='1';
    
end process;
end Behavioral;
