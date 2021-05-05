----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2020 01:48:46 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is

generic (rate: integer:=115_200);

  Port ( 
    clk: in std_logic;
    rst: in std_logic;
    start: in std_logic;
    TxData: in std_logic_vector(7 downto 0); --octetul care trebuie transmis
    Tx: out std_logic; --pe aici datele sunt transmise in mod serial
    TxRdy: out std_logic --stare activa => transmisia octetului a fost terminata
  );
end uart_tx;

architecture Behavioral of uart_tx is

--tip enumerat pentru starile din diagrama
type state is (ready, load, send, waitbit, shift); 
signal St: state:=ready;
constant freq: integer := 100_000_000;
constant T_BIT: integer := (freq/rate);

signal CntBit: integer:=0;
signal CntRate: integer:=0;

signal LdData: std_logic:='0';
signal ShData: std_logic:='0';
signal TxEn: std_logic:='0';

--registru deplasare
signal TSR: std_logic_vector(9 downto 0):=(others=>'0');

attribute keep : STRING;
attribute keep of St: signal is "TRUE";
attribute keep of CntBit: signal is "TRUE";
attribute keep of CntRate: signal is "TRUE";
attribute keep of TSR: signal is "TRUE";

begin

--proces pentru registrul de deplasare TSR cu rst sincron(nu se pune in lista)
deplasare: process(clk)
begin
   if rising_edge(clk) then
    if rst='1' then
        TSR <= (others=>'0');
    else 
        if LdData='1' then 
            TSR <= '1' & TxData & '0';
        elsif ShData='1' then
            TSR <= '0' & TSR(9 downto 1);
        end if;
    end if;
   end if;
end process;

-- Automat de stare pentru unitatea de control a transmitatorului serial
 proc_control: process (Clk)
 begin
 if RISING_EDGE (Clk) then
     if (Rst = '1') then
        St <= ready;
     else
         case St is
             when ready =>
             CntRate <= 0;
             CntBit <= 0;
             if (Start = '1') then
             St <= load;
             end if;
             
         when load =>
             St <= send;
         
        when send =>
             CntBit <= CntBit + 1;
             St <= waitbit;
             
        when waitbit =>
             CntRate <= CntRate + 1;
             if (CntRate = T_BIT -3) then
                 CntRate <= 0;
                 St <= shift;
             end if;
             
         when shift =>
             
             if (CntBit = 10) then
                St <= ready;
             else
                St <= send;
            end if;
            
         when others =>
            St <= ready;
         end case;
     end if;
 end if;
 end process proc_control;
-- Setarea semnalelor de comanda
 LdData <= '1' when St = load else '0';
 ShData <= '1' when St = shift else '0';
 TxEn <= '0' when St = ready or St = load else '1';
-- Setarea semnalelor de iesire
 Tx <= TSR(0) when TxEn = '1' else '1';
 TxRdy <= '1' when St = ready else '0'; 


end Behavioral;
