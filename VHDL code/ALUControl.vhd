----------------------------------------------------------------------------------------
-- This module is implements the ALUControl
-- 
-- Inputs:
--	- Funct	6-bit operand
--	- ALUOp 4-bit contol
--
-- Outputs:
--				
-- 	- Op		6-bit control	(for ALU)
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
		ALUOp					: in unsigned(3 downto 0);
		Funct					: in unsigned(5 downto 0);
		Op					: out unsigned(5 downto 0)
	);
end entity ALUControl;

architecture RTL of ALUControl is

begin process(clk)
	
begin

	if(rising_edge(clk)) then
		
		case ALUOp is
		
			when "0000" -- R Instruction
			
				Op <= Funct;
				
			when "0001" -- addi,lw,lb,sw,sb (do A + B in ALU)
			
				Op <= "100000";
				
			when "0010" -- beq,bne (do A-B in ALU)
			
				Op <= "100010";
				
			when "0011" -- slti (do slt(A,B) in ALU)
			
				Op <= "101010";
				
			when "0100" -- andi (do A and B in ALU)
			
				Op <= "100100";
				
			when "0101" -- ori (do A or B in ALU)
			
				Op <= "100101";
				
			when "0110" -- xori (do A xor B in ALU)
			
				Op <= "100110";
				
			when "0111" -- lui (do lui in ALU)
			
				--Op <= "foo"; define lui in ALU
				
			when "1000" -- jal
			
				-- TODO maybe not necessary
				
			when "1001" -- j
			
				-- TODO logic external to ALU
		
		end case;
		
	end if;

end process;
end architecture RTL;
