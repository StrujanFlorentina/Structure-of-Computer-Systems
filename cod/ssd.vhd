----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2020 22:16:49
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd is
 Port ( Digit: in std_logic_vector(15 downto 0);
        clk: in std_logic;
        an: out std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0));
end ssd;

architecture Behavioral of ssd is
signal Q : std_logic_vector(15 downto 0):=x"0000";
signal outmux:std_logic_vector(3 downto 0);
signal outmux2:std_logic_vector(3 downto 0);
begin

process(clk)
begin
 if rising_edge(clk) then
    Q <= Q +1;
    end if;
 end process;
    
 process(Q,Digit)
    begin
    case Q(15 downto 14) is
    when "00" => outmux <= Digit(3 downto 0);
    when "01" => outmux <= Digit(7 downto 4);
    when "10" => outmux <= Digit(11 downto 8);
    when "11" => outmux <=Digit(15 downto 12);
    when others => outmux <= "0000";
    end case;
 end process;
   
 process(Q)
    begin
    case Q(15 downto 14) is
      when "00" => outmux2 <= "1110";
    when "01" => outmux2 <= "1101";
    when "10" => outmux2 <= "1011";
    when "11" => outmux2 <= "0111";
    when others => outmux2 <= "0000";
    end case;
 end process;
    
   an <= outmux2;
      with outmux SELect
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

end Behavioral;
