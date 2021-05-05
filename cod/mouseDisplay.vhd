----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2021 12:20:37 PM
-- Design Name: 
-- Module Name: mouseDisplay - Behavioral
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

entity mouseDisplay is
  Port ( 
    clk: in std_logic;
    rst: in std_logic;
    ps2_clk: inout std_logic;
    ps2_data: inout std_logic;
    --afisam informatia pe leduri si ssd
    an: out std_logic_vector(3 downto 0);
    seg: out std_logic_vector(6 downto 0);
    led: out std_logic_vector(8 downto 0);
    
    --pentru uart
    Tx : out std_logic;
    Rdy : out std_logic
  );
end mouseDisplay;

architecture Behavioral of mouseDisplay is
signal Data: std_logic_vector(23 downto 0);
signal mouse_done: std_logic;

signal btn1, btn2,btn3, send, rdy1 : std_logic;
signal data1, data2,data3: std_logic_vector(63 downto 0);


constant s1: string:="buton stanga1234";
constant s2: string:="buton dreapta123";
constant s3: string:="buton mijloc1234";

begin

mouse: entity WORK.ps2_mouse port map(
    clk=>clk,
    rst=>rst,
    ps2_clk=>ps2_clk,  
    ps2_data=>ps2_data,
    mouseData=>Data,
    mouse_done=>mouse_done
);

ssd: entity WORK.ssd port map(
    Digit=>Data(15 downto 0),
    clk=>clk,
    an=>an,
    cat=>seg
);

uart: entity WORK.uart_send16 port map( Clk => Clk, 
                                        Rst => Rst, 
                                        Data1 => data1,
                                        Data2 => data2,
                                        Send => send, 
                                        Tx => Tx, 
                                        Rdy => rdy1 );
                                        

--in functie de ce buton al mouse-ului a fost apasat, vrem sa afisam un mesaj corespunzator
led<=mouse_done & Data(23 downto 16);

process(clk)
begin
    if rdy1='1' and (Data(0)='1' or Data(1)='1' or Data(2)='1') then
        send<='1';
    else 
        send<='0';
    end if;
end process;

process(clk)
begin                                   
    if RISING_EDGE(clk) then
        if rst='1' then
            data1 <= (others => '0');
            data2 <= (others => '0');
        else
            
            --buton stanga
            if rdy1='1' and Data(0)='1' then 
                data1<=S8_TOASCII(s1(1 to 8));
                data2<=S8_TOASCII(s1(9 to 16));
            end if;
            
            --buton dreapta
            if rdy1='1' and Data(1)='1' then 
                data1<=S8_TOASCII(s2(1 to 8));
                data2<=S8_TOASCII(s2(9 to 16));
            end if;
            
            --buton mijloc
            if rdy1='1' and Data(1)='1' then 
                data1<=S8_TOASCII(s3(1 to 8));
                data2<=S8_TOASCII(s3(9 to 16));
            end if;
            
        end if;
    end if;
end process;           


end Behavioral;
