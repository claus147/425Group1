----------------------------------------------------------------------------------------
-- This module is used to implement a 3x1MUX
-- 
-- Inputs:
--	- A			32-bit operand
--	- B			32-bit operand 
-- 
-- Output:
-- 	- R			32-bit result
-- 
-- Control:
-- 	- Op		choose between operations
-- 	- clk		clock
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_3to1 is
	port (
		A,B,C: in signed(31 downto 0);
		Op	: in std_ulogic_vector(1 downto 0);
		R	: out signed(31 downto 0)
	);
end entity MUX_3to1;

architecture RTL of MUX_3to1 is

begin 

process (clk)
	
begin
	case Op is
		when "00"  => 
			R <= A;
		when "01" => 
			R <= B;
		when "10" => 
			R <= C;
		when others => 
			NULL;
	end case;

end process;

end architecture RTL;
