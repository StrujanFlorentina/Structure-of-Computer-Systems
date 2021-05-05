library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package SSC_pkg is

-- Definitii de functii pentru conversii
function HEX2SSEG    (Hex : in STD_LOGIC_VECTOR (3 downto 0)) return STD_LOGIC_VECTOR;
function HEX_TOASCII (Hex : in STD_LOGIC_VECTOR (3 downto 0)) return STD_LOGIC_VECTOR;
function C_TOASCII   (C   : in CHARACTER) return STD_LOGIC_VECTOR;
function B2_TOASCII  (B2  : in STD_LOGIC_VECTOR (15 downto 0)) return STD_LOGIC_VECTOR;
function B4_TOASCII  (B4  : in STD_LOGIC_VECTOR (31 downto 0)) return STD_LOGIC_VECTOR;
function S4_TOASCII  (S4  : in STRING (1 to 4)) return STD_LOGIC_VECTOR;
function S8_TOASCII  (S8  : in STRING (1 to 8)) return STD_LOGIC_VECTOR;

end SSC_pkg;

package body SSC_pkg is

-- Functie de decodificare pentru afisajul cu 7 segmente
-- Codificarea segmentelor (biti 7..0): hgfe dcba (h - punctul zecimal)
--      a
--     ---  
--  f |   | b
--     ---    <- g
--  e |   | c
--     ---  . <- h
--      d
function HEX2SSEG (Hex : in STD_LOGIC_VECTOR (3 downto 0)) return STD_LOGIC_VECTOR is
	variable Sseg : STD_LOGIC_VECTOR (7 downto 0);
begin
    case Hex is
        when "0000" => Sseg := "11000000";  -- 0
        when "0001" => Sseg := "11111001";  -- 1
        when "0010" => Sseg := "10100100";  -- 2
        when "0011" => Sseg := "10110000";  -- 3
        when "0100" => Sseg := "10011001";  -- 4
        when "0101" => Sseg := "10010010";  -- 5
        when "0110" => Sseg := "10000010";  -- 6
        when "0111" => Sseg := "11111000";  -- 7
        when "1000" => Sseg := "10000000";  -- 8
        when "1001" => Sseg := "10010000";  -- 9
        when "1010" => Sseg := "10001000";  -- A
        when "1011" => Sseg := "10000011";  -- b
        when "1100" => Sseg := "11000110";  -- C
        when "1101" => Sseg := "10100001";  -- d
        when "1110" => Sseg := "10000110";  -- E
        when "1111" => Sseg := "10001110";  -- F
        when others => Sseg := "11111111";
    end case;
	return Sseg;
end function HEX2SSEG;

-- Functie de conversie a unei cifre hexazecimale in codul ASCII
function HEX_TOASCII (Hex : in STD_LOGIC_VECTOR (3 downto 0)) return STD_LOGIC_VECTOR is
	variable Ascii : STD_LOGIC_VECTOR (7 downto 0);
begin
	if (Hex > x"9") then
		Ascii := x"0" & Hex + x"37";
	else
		Ascii := x"0" & Hex + x"30";
	end if;
	return Ascii;
end function HEX_TOASCII;

-- Functie de conversie a unui caracter intr-un vector
-- de 8 biti continand codul ASCII al caracterului
function C_TOASCII (C : in CHARACTER) return STD_LOGIC_VECTOR is
	variable Poz   : INTEGER;
	variable Ascii : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin
	Poz := CHARACTER'pos (C);			-- pozitia caracterului in tipul enumerat CHARACTER
	for i in 0 to 7 loop
		if ((Poz/(2**i)) mod 2 = 1) then
			Ascii (i) := '1';
		end if;
	end loop;
	return Ascii;
end function C_TOASCII;

-- Functie de conversie a doi octeti intr-un vector de 32 de biti
-- continand codurile ASCII ale cifrelor hexazecimale ale octetilor
function B2_TOASCII (B2 : in STD_LOGIC_VECTOR (15 downto 0)) return STD_LOGIC_VECTOR is
	variable Ascii_1 : STD_LOGIC_VECTOR (7 downto 0);
	variable Ascii_2 : STD_LOGIC_VECTOR (7 downto 0);
	variable Ascii_3 : STD_LOGIC_VECTOR (7 downto 0);
	variable Ascii_4 : STD_LOGIC_VECTOR (7 downto 0);
begin
	Ascii_1 := HEX_TOASCII (B2(15 downto 12));
	Ascii_2 := HEX_TOASCII (B2(11 downto 8));
	Ascii_3 := HEX_TOASCII (B2(7  downto 4));
	Ascii_4 := HEX_TOASCII (B2(3  downto 0));
	return Ascii_1 & Ascii_2 & Ascii_3 & Ascii_4;
end function B2_TOASCII;

-- Functie de conversie a patru octeti intr-un vector de 64 de biti
-- continand codurile ASCII ale cifrelor hexazecimale ale octetilor
function B4_TOASCII (B4 : in STD_LOGIC_VECTOR (31 downto 0)) return STD_LOGIC_VECTOR is
	variable Ascii_1_4 : STD_LOGIC_VECTOR (31 downto 0);
	variable Ascii_5_8 : STD_LOGIC_VECTOR (31 downto 0);
begin
	Ascii_1_4 := B2_TOASCII (B4(31 downto 16));
    Ascii_5_8 := B2_TOASCII (B4(15 downto 0));
	return Ascii_1_4 & Ascii_5_8;
end function B4_TOASCII;

-- Functie de conversie a unui sir de 4 caractere intr-un vector
-- de 32 de biti continand codurile ASCII ale caracterelor
function S4_TOASCII (S4 : in STRING (1 to 4)) return STD_LOGIC_VECTOR is
	variable Ascii_1 : STD_LOGIC_VECTOR (7 downto 0);
	variable Ascii_2 : STD_LOGIC_VECTOR (7 downto 0);
	variable Ascii_3 : STD_LOGIC_VECTOR (7 downto 0);
	variable Ascii_4 : STD_LOGIC_VECTOR (7 downto 0);
begin
	Ascii_1 := C_TOASCII (S4(1));
	Ascii_2 := C_TOASCII (S4(2));
	Ascii_3 := C_TOASCII (S4(3));
	Ascii_4 := C_TOASCII (S4(4));
	return Ascii_1 & Ascii_2 & Ascii_3 & Ascii_4;
end function S4_TOASCII;

-- Functie de conversie a unui sir de 8 caractere intr-un vector
-- de 64 de biti continand codurile ASCII ale caracterelor
function S8_TOASCII (S8 : in STRING (1 to 8)) return STD_LOGIC_VECTOR is
	variable Ascii_1_4 : STD_LOGIC_VECTOR (31 downto 0);
    variable Ascii_5_8 : STD_LOGIC_VECTOR (31 downto 0);
begin
	Ascii_1_4 := S4_TOASCII (S8(1 to 4));
    Ascii_5_8 := S4_TOASCII (S8(5 to 8));
    return Ascii_1_4 & Ascii_5_8;
end function S8_TOASCII;

end SSC_pkg;
