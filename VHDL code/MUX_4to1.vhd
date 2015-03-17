----------------------------------------------------------------------------------------
-- This module is used to implement a 4x1MUX
-- 
-- Inputs:
--	- A			32-bit operand signed
--	- B			32-bit operand signed
--	- C			32-bit operand signed
--	- D			32-bit operand signed
-- 
-- Output:
-- 	- R			32-bit result signed
-- 
-- Control:
-- 	- Op		choose between operations
-- 	- clk		clock
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_4to1 is
	port (
		A,B,C,D: in signed(31 downto 0);
		Op	: in std_ulogic_vector(1 downto 0);
		R	: out signed(31 downto 0)
	);
end entity MUX_4to1;

architecture RTL of MUX_4to1 is

begin 
  
with Op select
  R <= A when "00",
       B when "01",
       C when "10",
       D when others;

end architecture RTL;
