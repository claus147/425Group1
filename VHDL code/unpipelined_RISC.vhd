----------------------------------------------------------------------------------------
-- This module is used to combine individual components 
-- This module takes as input a series of instructions stored in the Instruction Memory
-- The unpipelined RISC processor is composed of:
-- 		- PC					26-bit address initialized to 0x0		
--		- 32-bit registers		R0 wired to 0x0000						SETUP need a table that maps address to data
--		- IR					breakdown the instruction				SETUP
--		- ALU															IN PROGRESS
--		- Multiplexers			4 32-bit MUX							DONE!
--		- Adder					increment PC							DONE!
--		- Control module		translate opcode to control bits		SETUP
--
-- The results of this module is stored in Data Memory
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unpipelined_RISC is
	port (
		clk : in std_logic;
		rst : in std_logic
	);
end entity unpipelined_RISC;

architecture RTL of unpipelined_RISC is
	
begin

end architecture RTL;
