----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2020 11:02:37 AM
-- Design Name: 
-- Module Name: modul_principal - Behavioral
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
use work.SSC_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testEnt is
    Port ( clk : in std_logic;
           rst : in std_logic;
           buton1, buton2,buton3: in std_logic;
           Tx : out std_logic;
           Rdy : out std_logic);
end testEnt;

architecture Behavioral of testEnt is

signal btn1, btn2,btn3, send, rdy1 : std_logic;
signal data1, data2,data3: std_logic_vector(63 downto 0);

constant s1: string:="buton stanga1234";
constant s2: string:="buton dreapta123";
constant s3: string:="buton mijloc1234";

begin

uart: entity WORK.uart_send24 port map( Clk => Clk, 
                                        Rst => Rst, 
                                        Data1 => data1,
                                        Data2 => data2,
                                        Data3 => data3,
                                        Send => send, 
                                        Tx => Tx, 
                                        Rdy => rdy1 );

debounce1: entity WORK.debounce port map (clk => Clk, 
                                    rst => Rst, 
                                    din => buton1, 
                                    qout => btn1);
                                    
debounce2: entity WORK.debounce port map (clk => Clk, 
                                    rst => Rst, 
                                    din => buton2, 
                                    qout => btn2);

debounce3: entity WORK.debounce port map (clk => Clk, 
                                    rst => Rst, 
                                    din => buton3, 
                                    qout => btn3);    
                                    
process(clk)
begin
    if rdy1='1' and (btn1='1' or btn2='1' or btn3='1') then
        send<='1';
    else 
        send<='0';
    end if;
end process;

process(Clk)
begin                                   
    if RISING_EDGE(Clk) then
        if Rst='1' then
            data1 <= (others => '0');
            data2 <= (others => '0');
        else
            
            if rdy1='1' and btn1='1' then 
                data1<=S8_TOASCII(s1(1 to 8));
                data2<=S8_TOASCII(s1(9 to 16));
            end if;
            
            if rdy1='1' and btn2='1' then 
                data1<=S8_TOASCII(s2(1 to 8));
                data2<=S8_TOASCII(s2(9 to 16));
            end if;
            
            if rdy1='1' and btn3='1' then 
                data1<=S8_TOASCII(s3(1 to 8));
                data2<=S8_TOASCII(s3(9 to 16));
            end if;
            
        end if;
    end if;
end process;                                              
end Behavioral;
