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

entity MUX is
	port (
		dat  	: in signed(31 downto 0);
		sel   : in std_logic;
		inst  : out unsigned(31 downto 0);
		memIO : inout std_logic_vector(31 downto 0)
	);
end entity MUX;

architecture RTL of MUX is

begin 
with sel select 
  inst <= unsigned(memIO) when '0',
          "00000000000000000000000000000000" when others;
with sel select          
  memIO <= std_logic_vector(dat) when '1',
           memIO when others;

end architecture RTL;