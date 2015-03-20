----------------------------------------------------------------------------------------
-- This module is used to implement an IO_MUX
-- 
-- Inputs:
--	- dat			32-bit signed operand
-- 
-- Output:
-- 	- instruction			32-bit unsigned instruction
--
-- Input/Output:
--  - memIO     32-bit std_logic_vector
-- 
-- Control:
-- 	- sel  std_logic
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IO_MUX is
	port (
	  rst   : in std_logic;
		dat  	: in std_logic_vector(31 downto 0);
		sel   : in std_logic;
		inst  : out std_logic_vector(31 downto 0);
		memIO : inout std_logic_vector(31 downto 0)
	);
end entity IO_MUX;

architecture RTL of IO_MUX is
begin 
  --set the data to the memory input/ouput line when select is high, else set it to high impedance
  memIO <= std_logic_vector(dat) when sel = '1'else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
  --set the memory input/ouput line to the insruction reister when select line is low, else set it to high impedance 
  inst <= memIO when sel = '0' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";


end architecture RTL;