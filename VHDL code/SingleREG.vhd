----------------------------------------------------------------------------------------
-- This module is used to as a register that stores one value (PC, A, B, ALUout)
-- 
--	
-- Control:
-- 	- clk		clock
--	- rst		reset
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
		reg_in				: in unsigned(31 downto 0);
		reg_out				: out unsigned(31 downto 0)
	);
end entity SingleREG;

architecture arch of SingleREG is

	begin process(clk)
	
		begin
			if(rising_edge(clk)) then
				reg_out <= reg_in;
		
			end if;
		
	end process;
end architecture arch;
