----------------------------------------------------------------------------------------
-- This module is used to implement the PC adder
-- 
-- Inputs:
--	- PC		26-bit operand
-- 
-- Output:
-- 	- NPC		26-bit result
-- 
-- Control:
-- 	- clk		clock
-- 	- rst		reset
--
-- The results of this module points to the next instruction to be executed
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_add is
	port (
		clk : in std_logic;
		rst : in std_logic;
		PC	: in unsigned(31 downto 0);
		NPC : out unsigned(31 downto 0)
	);
end entity PC_add;

architecture RTL of PC_add is
  
  

begin 
  
  NPC <= PC + 4;

--process(clk)
	
--begin

	--if(rising_edge(clk)) then
		
	--	NPC <= PC +4;
		
	--end if;

--end process;
end architecture RTL;
