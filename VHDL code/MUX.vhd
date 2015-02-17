----------------------------------------------------------------------------------------
-- This module is used to implement a 2x1MUX
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

entity MUX is
	port (
		clk : in std_logic;
		rst : in std_logic;
		A, B: in signed(31 downto 0);
		Op	: in std_logic;
		R	: out signed(31 downto 0)
	);
end entity MUX;

architecture RTL of MUX is

begin process (clk)
	
begin

	if (rising_edge(clk)) then
		case Op is
			when "0"  => 
				R <= A;
			when "1" => 
				R <= B;
			when others => 
				NULL;
		end case;
	end if;

end process;

end architecture RTL;
