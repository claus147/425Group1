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
		IRwrite				: in std_logic;
		Ins					: in unsigned(31 downto 0);
		--Op_code, Funct	: out unsigned(5 downto 0);
		--Rs, Rt, Rd, Shamt	: out unsigned(4 downto 0);
		--Imm				: out unsigned(15 downto 0);
		--Addr				: out unsigned(25 downto 0)
		ins_out				:out std_ulogic_vector(31 downto 0)
	);
end entity INSTR;

architecture RTL of INSTR is

begin process(clk)

begin
	if(rising_edge(clk) and IRwrite = '1') then
	
		ins_out <= std_ulogic_vector(ins);
		--Op_code <= Ins(31 downto 26);
		--Rs <= Ins(25 downto 21);
		--Rt <= Ins(20 downto 16);
		--Rd <= Ins(15 downto 11);
		--Shamt <= Ins(10 downto 6);
		--Funct <= Ins(5 downto 0);
		--Imm <= Ins(15 downto 0);
		--Addr <= Ins(25 downto 0); 

	end if;
	
end process;
end architecture RTL;
