----------------------------------------------------------------------------------------
-- This module is implements the ALUControl
-- 
-- Inputs:
--	- Funct		6-bit operand
--	
--
-- Outputs:
--				
-- 	- Op		6-bit control	(for ALU)
--		
-- Control:
-- 	- clk		clock
--	- rst		reset
-- 	- ALUOp 	4-bit contol
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
		ALUOp					: in std_ulogic_vector(3 downto 0);
		Funct					: in std_ulogic_vector(5 downto 0);
		Op					: out std_ulogic_vector(5 downto 0)
	);
end entity ALUControl;

architecture RTL of ALUControl is

begin process(clk)
	
begin

	if(rising_edge(clk)) then
		
		case ALUOp is
		
			when "0000" => 		-- R Instruction
			
				Op <= Funct;
				
			when "0001" =		 -- addi,lw,lb,sw,sb (do A + B in ALU)
			
				Op <= "100000";
				
			when "0010" => 		-- beq,bne (do A-B in ALU)
			
				Op <= "100010";
				
			when "0011" => 		-- slti (do slt(A,B) in ALU)
			
				Op <= "101010";
				
			when "0100" => 		-- andi (do A and B in ALU)
			
				Op <= "100100";
				
			when "0101" =		-- ori (do A or B in ALU)
			
				Op <= "100101";
				
			when "0110" => 		-- xori (do A xor B in ALU)
			
				Op <= "100110";
				
			when "0111" => 		-- lui (do lui in ALU)
			
				Op <= "111111";
				
			when others =>
			
				null;
		
		end case;
		
	end if;

end process;
end architecture RTL;
