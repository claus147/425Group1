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
-- 	- clk		clock
-- 
-- The results of this module is stored in Data Memory
--
----------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU is
	port (
		clk 	: in std_logic;
		rst 	: in std_logic;
		A, B	: in signed(31 downto 0);
		Op		: in unsigned(4 downto 0);
		R		: out signed(31 downto 0);
		C_out	: out std_logic
	);
end entity ALU;

architecture RTL of ALU is
signal B_int : integer;
begin process(clk)
	
begin
	
	if(rising_edge(clk)) then
		case Op is
			when "00000" => 		-- 00000	ADD, ADDI,
				R  <= A+B;
			
			when "00001" => 		-- 00001	SUB
				R <= A-B;
				
			when "00010" => 		-- 00010	MULT
				R <= A*B;
			
			when "00011" =>
				R <= A / B;
			
			when "00100" => 
				if (A<B) then
					R <= "00000000000000000000000000000001";
				else
					R <= "00000000000000000000000000000000";  
				end if;
				
			when "00101" => 
				R <= A and B;
			
			when "00110" => 
				R <= A or B;
			
			when "00111" => 
				R <= A nor B;
			
			when "01000" => 
				R <= A xor B;
			
			when "01001" => 
				R <= B (31 downto 16);
			
			when "01010" => 
				R <= B (15 downto 0);
				
			when "01011" => 
				R <= B (30 downto 0);
			
			when "01100" => 
				
				B_int <= to_integer(B);
				R <= A sll B_int;
				
			when "01101" =>
				
				B_int <= to_integer(B);
				R <= A srl B_int;
			
			when "01110" => 
				B_int <= to_integer(B);
				R <= A +Shift_right(A, B_int);
			
			when others => 
				NULL;
			
		end case;
		
	end if;
		
end process;
end architecture RTL;
