----------------------------------------------------------------------------------------
-- This module is used to implement the BranchAdder
-- 
-- Inputs:
--	- PC		32-bit operand
--	- Offset	32-bit operand
-- 
-- Output:
-- 	- NPC		32-bit result
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
		--clk       	: in std_logic;
		--rst		: in std_logic;
		PC	      	: in signed(31 downto 0);
        	Offset    	: in signed(31 downto 0);
		NPC       	: out signed(31 downto 0)
	);
end entity BranchAdder;

architecture RTL of BranchAdder is

    	signal offsetShifted : signed(31 downto 0);

begin 
       
        offsetShifted <= shift_left(Offset,2);
	NPC <= PC + offsetShifted;
    
end architecture RTL;
