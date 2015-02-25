----------------------------------------------------------------------------------------
-- This module is used to extend the instuction from 16-bit to 32-bit
-- 
-- Inputs:
--	- Immediate		16-bit operand
-- 
-- Output:
-- 	- Extended 	  	32-bit result
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtender is
  port (

		Immediate   : in signed(15 downto 0);
		Extended    : out signed(31 downto 0)
	);
end entity SignExtender;

architecture RTL of SignExtender is

begin 

	Extended <= resize(Immediate,32);
    
end architecture RTL;
