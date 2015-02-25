----------------------------------------------------------------------------------------
-- This module is used to break down the OP_code into different control lines
-- 
-- Inputs:
--	- OP_code	6-bit operand
-- 
-- Outputs:						there are a few missing~ ok missing a lot
-- 	- funct		6-bit control	(for ALU)
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
		OP_code					: in STD_LOGIC_VECTOR(5 downto 0); --we need both opcode (6 MSBs)
		funct					: in STD_LOGIC_VECTOR(5 downto 0); --and funct (6 LSBs) from instr to determine what we are actually executing
		ALU_op					: out unsigned(4 downto 0);
		R_type, I_type, J_type	: out std_logic 
		
	);
end entity OPCODE;

architecture RTL of OPCODE is

begin process(clk)
	
begin

	if(rising_edge(clk)) then
		if (Op_code = x"0") then -- ALU functions are when opcode is 0
			
			R_type <= '1';
			I_type <= '0';
			J_type <= '0';
			
			if (funct = x"20") then 	--add 
				
			elsif (funct = x"22") then 	--sub
			
			elsif (funct = x"18") then 	--mult
			
			elsif (funct = x"1a") then 	--div	
			
			elsif (funct = x"2a") then 	--slt (set less than)
				
			elsif (funct = x"24") then 	--and	
			
			elsif (funct = x"25") then 	--or
		
			elsif (funct = x"27") then 	--nor
				
			elsif (funct = x"26") then 	--xor
				
			elsif (funct = x"10") then 	--mfhi (move from HI)
			
			elsif (Op_code = x"12") then 	--mflo (move from LO) 
				
			elsif (funct = x"0") then 	--sll (shift left logical)
		
			elsif (funct = x"2") then 	--srl (shift right logical)
			
			elsif (funct = x"3") then 	--sra (shift left arithmetic)
				
			elsif (funct = x"8") then 	--jr (jump register)
			
			end if;
		
		elsif (Op_code = x"2") then 		--j
			R_type <= '0';
			I_type <= '0';
			J_type <= '1';
		elsif (Op_code = x"3") then 		--jal (jump and link)	
			R_type <= '0';
			I_type <= '0';
			J_type <= '1';
		else
			R_type <= '0';
			I_type <= '1';
			J_type <= '0';
			
			if (Op_code = x"8") then 	--addi
				
			elsif (Op_code = x"a") then 	--slti
				
			elsif (Op_code = x"c") then 	--andi
			
			elsif (Op_code = x"d") then 	--ori
			
			elsif (Op_code = x"e") then 	--xori
			
			elsif (Op_code = x"f") then 	--lui (load upper immediate)
			
			elsif (Op_code = x"23") then 	--lw (load word)
			
			elsif (Op_code = x"20") then 	--lb (load byte)
			
			elsif (Op_code = x"2b") then 	--sw
			
			elsif (Op_code = x"28") then 	--sb
			
			elsif (Op_code = x"4") then 	--beq
			
			elsif (Op_code = x"5") then 	--bne
			
			end if;	
		end if; 
		
	end if;

end process;
end architecture RTL;
