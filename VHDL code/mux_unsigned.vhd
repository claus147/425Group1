----------------------------------------------------------------------------------------
-- This module is used to implement a 2x1MUX
-- 
-- Inputs:
--	- A			32-bit unsigned operand
--	- B			32-bit unsigned operand 
-- 
-- Output:
-- 	- R			32-bit unsigned result
-- 
-- Control:
-- 	- Op		choose between operations
-- 	- clk		clock
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_unsigned is
	port (
		A, B: in unsigned(31 downto 0);
		Op	: in std_logic;
		R	: out unsigned(31 downto 0)
	);
end entity MUX_unsigned;

architecture RTL of MUX_unsigned is

begin process (Op)
	
begin
	case Op is
		when '0'  => 
			R <= A;
		when '1' => 
			R <= B;
		when others => 
			NULL;
	end case;

end process;

end architecture RTL;
