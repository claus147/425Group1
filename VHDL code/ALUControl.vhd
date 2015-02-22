----------------------------------------------------------------------------------------
-- This module is implements the ALUControl
-- 
-- Inputs:
--	- Funct	5-bit operand
—-	- ALUOp 2-bit contol
-- 
-- Outputs:
—-				
-- 	- Op		5-bit control	(for ALU)
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

entity ALUControl is
	port (
		clk 					: in std_logic;
		rst 					: in std_logic;
		ALUOp					: in unsigned(1 downto 0);
		Funct					: in unsigned(4 downto 0);
		Op					: out unsigned(4 downto 0);
	);
end entity ALUControl;

architecture RTL of ALUControl is

begin process(clk)
	
begin

	if(rising_edge(clk)) then
		
		
		
	end if;

end process;
end architecture RTL;