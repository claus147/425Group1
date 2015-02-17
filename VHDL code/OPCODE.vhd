----------------------------------------------------------------------------------------
-- This module is used to break down the OP_code into different control lines
-- 
-- Inputs:
--	- OP_code	6-bit operand
-- 
-- Outputs:						there are a few missing~ ok missing a lot
-- 	- Op		5-bit control	(for ALU)
-- 	- R_type	1-bit control
--	- I_type	1-bit control
--	- J_type	1-bit control
--		
-- Control:
-- 	- clk		clock
-- 
-- The results of this module used to control the ALU, registers and some logic gates
--
----------------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OPCODE is
	port (
		clk 					: in std_logic;
		rst 					: in std_logic;
		OP_code					: in unsigned(5 downto 0);
		Op						: out unsigned(4 downto 0);
		R_type, I_type, J_type	: out std_logic
	);
end entity OPCODE;

architecture RTL of OPCODE is

begin process(clk)
	
begin

	if(rising_edge(clk)) then
		
		
	end if;

end process;
end architecture RTL;
