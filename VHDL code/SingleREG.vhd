----------------------------------------------------------------------------------------
-- This module is used to as a register that stores one value (PC, A, B, ALUout)
-- 
--	Inputs:
--	- reg_in	input of the register unsigned
--
--
--	Outputs:
--	- reg_out	output of the register unsigned
--	
--	Control:
-- 	- clk		clock
--	- rst		reset
--	- write_pc	write pc control signal
-- 
-- The module will present its input at the output on the clock edge
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SingleREG is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		write_pc			: in std_logic;
		reg_in				: in unsigned(31 downto 0);
		reg_out				: out unsigned(31 downto 0)
	);
end entity SingleREG;

architecture arch of SingleREG is  

begin 
	process(clk,rst,write_pc)
	begin
	  if(rst = '1') then
	   reg_out <= (OTHERS => '0');
		elsif(falling_edge(clk) and write_pc = '0') then
				reg_out <= reg_in;	-- present the input at the output of the register on the clock edge and when write_pc is high
		end if;	
	end process;
end architecture arch;
