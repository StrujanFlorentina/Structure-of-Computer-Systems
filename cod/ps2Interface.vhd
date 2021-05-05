----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2020 03:47:50 PM
-- Design Name: 
-- Module Name: ps2Interface - Behavioral
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

entity ps2Interface is
 Port ( 
    clk:    in std_logic;
    rst:    in std_logic;
    --pentru transmisie 7 sau 8 biti
    tx_data: in std_logic_vector(7 downto 0); --8 biti de comanda de transmit
    rx_data: out std_logic_vector(7 downto 0);
    
    tx_en:  in std_logic; --se poate transmite
    rx_en:  in std_logic;
    
    ps2_clk: inout std_logic;
    ps2_data: inout std_logic;
    
    tx_busy: out std_logic; --transmisie in progres
    tx_done: out std_logic; --s-a terminat transmisia

    rx_done: out std_logic;
    rx_error: out std_logic

 );
end ps2Interface;

architecture Behavioral of ps2Interface is

begin


tx: entity WORK.ps2_tx port map(
    clk=>clk,    
    rst=>rst,    
    tx_data=>tx_data,
    tx_en=>tx_en,
    ps2_clk=>ps2_clk,
    ps2_data=>ps2_data,
    tx_busy=>tx_busy,
    tx_done=>tx_done
);

rx: entity WORK.ps2_rx port map(
    clk=>clk,  
    rst=>rst,
    ps2_clk=>ps2_clk,
    ps2_data=>ps2_data,
            
    rx_en=>rx_en, 
    rx_data=>rx_data,
    rx_done=>rx_done,
    rx_error=>rx_error
);

end Behavioral;
