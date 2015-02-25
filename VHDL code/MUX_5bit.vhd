----------------------------------------------------------------------------------------
-- This module is used to implement a MUX 5-bit
-- 
-- Inputs:
--	- A			5-bit operand
--	- B			5-bit operand 
-- 
-- Output:
-- 	- R			5-bit result
-- 
-- Control:
-- 	- Op		choose between operations
-- 	- clk		clock
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_5bit is
	port (
		A,B	: in signed(4 downto 0);
		Op	: in std_ulogic_vector(1 downto 0);
		R	: out signed(4 downto 0)
	);
end entity MUX_5bit;

architecture RTL of MUX_5bit is

begin 

process (clk)
	
begin
	case Op is
		when "00"  => 
			R <= A;
		when "01" => 
			R <= B;
		when "10" => 
			R <= "11111";
		when others => 
			NULL;
	end case;

end process;

end architecture RTL;
