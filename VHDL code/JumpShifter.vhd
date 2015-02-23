----------------------------------------------------------------------------------------
-- This module is used to implement the JumpShifter
-- 
-- Inputs:
--	- Unshifted		26-bit operand
-- 
-- Output:
-- 	- Shifted 	  28-bit result
-- 
-- Control:
-- 	- clk		clock
-- 
-- The results of this module is passed to
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity JumpShifter is
  port (
		clk         	: in std_logic;
		rst		: in std_logic;
		Unshifted   	: in signed(25 downto 0);
		Shifted    	: out signed(27 downto 0)
	);
end entity JumpShifter;

architecture RTL of JumpShifter is

signal tmp: signed(27 downto 0);

begin 

	tmp <= resize(Unshifted,28);
	Shifted <= shift_left(tmp,2);
    
end architecture RTL;
