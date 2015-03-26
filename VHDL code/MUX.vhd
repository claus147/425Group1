----------------------------------------------------------------------------------------
-- This module is used to implement a 2x1MUX
-- 
-- Inputs:
--	- A			32-bit signed operand
--	- B			32-bit signed operand 
-- 
-- Output:
-- 	- R			32-bit signed result
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
		A, B: in signed(31 downto 0);
		Op	: in std_logic;
		R	: out signed(31 downto 0)
	);
end entity MUX;

architecture RTL of MUX is

begin 

with Op select 
  R <= B when '1',
       A when others;
  

end architecture RTL;
