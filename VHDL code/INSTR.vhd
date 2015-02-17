----------------------------------------------------------------------------------------
-- This module is used to break down the instruction
-- 
-- Inputs:
--	- Inst		32-bit operand
-- 
-- Outputs:						
-- 	- Op_code	6-bit control	
--	- Rs		5-bit operand
--	- Rt		5-bit operand
--	- Rd		5-bit operand
--	- Shamt		5-bit operand
--	- Funct		6-bit operand
--	- Imm		16-bit immediate 
--	- Addr		26-bit address
--	
-- Control:
-- 	- clk		clock
-- 
-- The results of this module will be put on the data lines
-- The OPCODE module will determine how these outputs are used
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTR is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		Ins					: in unsigned(31 downto 0);
		Op_code, Funct		: out unsigned(5 downto 0);
		Rs, Rt, Rd, Shamt	: out unsigned(4 downto 0);
		Imm					: out unsigned(15 downto 0);
		Addr				: out unsigned(25 downto 0)
	);
end entity INSTR;

architecture RTL of INSTR is

begin process(clk)

begin
	if(rising_edge(clk)) then
		
	end if;
	
end process;
end architecture RTL;
