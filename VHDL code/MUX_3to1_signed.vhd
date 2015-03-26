----------------------------------------------------------------------------------------
-- This module is used to implement a 3x1MUX
-- 
-- Inputs:
--	- A			32-bit operand unsigned
--	- B			32-bit operand unsigned
--	- C			32-bit operand unsigned
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

entity MUX_3to1_signed is
	port (
		A,B,C	: in signed(31 downto 0);
		Op		: in std_ulogic_vector(1 downto 0);
		R		: out signed(31 downto 0)
	);
end entity MUX_3to1_signed;

architecture RTL of MUX_3to1_signed is

begin 
  
with Op select 
  R <= A when "00",
       B when "01",
       C when "10",
       A when OTHERS;


end architecture RTL;


