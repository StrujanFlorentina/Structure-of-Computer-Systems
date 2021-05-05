----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/11/2021 09:22:32 PM
-- Design Name: 
-- Module Name: tx_tb - Behavioral
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

entity tx_tb is
--  Port ( );
end tx_tb;

architecture Behavioral of tx_tb is
signal clk:     std_logic;
signal rst:     std_logic;
signal ps2_clk: std_logic;
signal ps2_data:std_logic;
         
signal tx_en:   std_logic;
signal tx_data: std_logic_vector(7 downto 0);
signal tx_done: std_logic;
signal tx_busy :std_logic;
constant clk_period: time:= 20 ns;
begin

DUT: entity WORK.ps2_tx port map(
    clk=>clk,    
    rst=>rst,
    tx_data =>tx_data,
    tx_en => tx_en,
    ps2_clk=>ps2_clk,
    ps2_data=>ps2_data,
    tx_busy => tx_busy,
    tx_done => tx_done
);

clkProcess: process
begin
    clk<='0';
    wait for clk_period/2;
    clk<='1';
    wait for clk_period/2;
end process;

sim:process
begin
    rst<='1';
    wait for 10ns;
    rst<='0';
    ps2_clk<='1';
    ps2_data<='1';
    
    tx_en<='1';
    wait;
end process;
end Behavioral;
