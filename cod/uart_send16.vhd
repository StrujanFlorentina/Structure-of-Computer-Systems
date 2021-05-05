----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2020 11:10:52 PM
-- Design Name: 
-- Module Name: uart_send16 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_send16 is
    Port (Clk: in std_logic;
          Rst: in std_logic;
          Data1: in std_logic_vector(63 downto 0);
          Data2: in std_logic_vector(63 downto 0);
          Send: in std_logic;
          Tx: out std_logic;
          Rdy: out std_logic);
end uart_send16;

architecture Behavioral of uart_send16 is

signal CR: std_logic_vector(7 downto 0) :=x"0D";
signal LF: std_logic_vector(7 downto 0) :=x"0A";

signal TxData: std_logic_vector(7 downto 0);
signal Start: std_logic;
signal TxRdy: std_logic;

type state is (incep, incarc, astept, transmit, final);
signal stare: state;

signal cnt: integer := 0;
signal counter: integer := 0;

begin

uart_tx: entity WORK.uart_tx port map (TxData => TxData,
                                        Clk => Clk,
    	                                Rst => Rst,
    	                                Start => Start,
    	                                Tx => Tx,
    	                                TxRdy => TxRdy);


--automat de stare cu proces secvential pt fiecare caracter din sir
numarator: process(clk)
begin
 if rising_edge(clk) then
     if rst='1' then
        counter<=0;
    
     elsif stare=transmit then
            counter <= counter + 1;
     
     elsif stare=final then
        counter<=0;
     end if;
 end if;
 end process;
 
 
automat: process(clk)
    begin
     if rising_edge(clk) then
         if rst='1' then
            stare<=incep;
         else
             case stare is
                 when incep =>
                 if Send='1' then
                    --incep transmisia caracterului
                     stare<=incarc;
                 end if;
                
                 when incarc =>
                   if counter=18 then
                        stare<=final;
                    else 
                        stare<=astept;
                   end if;
                
                 when astept =>
                    if TxRdy='1' then
                        stare<=transmit;
                     end if;
                
                 when transmit =>
                    stare<=incarc;
                
                 when final =>
                    stare<=incep;
                
             end case;
         end if;
       
 end if;
end process;
start <= '1' when (stare=incarc) else '0';
Rdy <= '1' when (stare=incep) else '0';


with counter select
 TxData <= Data1(63 downto 56) when 00,
 Data1(55 downto 48) when 01,
 Data1(47 downto 40) when 02,
 Data1(39 downto 32) when 03,
 Data1(31 downto 24) when 04,
 Data1(23 downto 16) when 05,
 Data1(15 downto 8) when 06,
 Data1(7 downto 0) when 07,
 
 Data2(63 downto 56) when 08,
 Data2(55 downto 48) when 09,
 Data2(47 downto 40) when 10,
 Data2(39 downto 32) when 11,
 Data2(31 downto 24) when 12,
 Data2(23 downto 16) when 13,
 Data2(15 downto 8) when 14,
 Data2(7 downto 0) when 15,
  
 CR when 16,
 LF when 17,
 x"00" when others;

end Behavioral;
