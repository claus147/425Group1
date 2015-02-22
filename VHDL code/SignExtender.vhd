----------------------------------------------------------------------------------------
-- This module is used to implement the SignExtender
-- 
-- Inputs:
--	- Immediate		16-bit operand
-- 
-- Output:
-- 	- Extended 	  32-bit result
-- 
-- Control:
-- 	- clk		clock
-- 
-- The results of this module is passed to the BranchMux
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BranchAdder is
  port (
	  clk         : in std_logic;
		rst		      : in std_logic;
		Immediate   : in signed(15 downto 0);
		Extended    : out signed(31 downto 0)
	);
end entity BranchAdder;

architecture RTL of BranchAdder is

begin 

	process(clk)
	
    	begin

	   	if(rising_edge(clk)) then
       
        Extended <= resize(Immediate,32);
		
	   	end if;

    	end process;
    
end architecture RTL;
