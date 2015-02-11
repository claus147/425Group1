----------------------------------------------------------------------------------------
-- This module is used to implement the ALU
-- 
-- Inputs:
--	- A			32-bit operand
--	- B			32-bit operand 
-- 
-- Output:
-- 	- R			32-bit result
-- 
-- Control:
-- 	- Op		choose between operations
-- 	- Clk		clock
-- 
-- The results of this module is stored in Data Memory
--
----------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port (
		clk : in std_logic;
		rst : in std_logic;
		A, B: in signed(31 downto 0);
		Op	: in unsigned(4 downto 0);
		R	: out signed(31 downto 0)
	);
end entity ALU;

architecture RTL of ALU is

begin process(Clk)
	
begin
	
	if(rising_edge(Clk)) then
		case Op is
			when "00000" => 		-- 00000	add
				R  <= A+B;
			
			when "00001" => 
				R <= A-B;
				
			when "00010" => 
				R <= A*B;
			
				
			when others => 
				NULL;
			
		end case;
		
	end if;
		
end process;
end architecture RTL;
