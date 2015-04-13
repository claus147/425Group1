----------------------------------------------------------------------------------------
-- This module is used to implement the ALU
-- 
-- Inputs:
--	- A		32-bit operand
--	- B		32-bit operand 
-- 
-- Output:
-- 	- R		32-bit result
-- 	- zero		1-bit result
--
-- Control:
-- 	- Op		choose between operations
-- 	- clk		clock
--	- rst		reset
-- 
----------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU is
	port (
		rst 		: in std_logic;
		A, B		: in signed(31 downto 0);
		Op		: in std_ulogic_vector(5 downto 0);
		R		: out signed(31 downto 0);
		zero		: out std_logic
	);
end entity ALU;

architecture RTL of ALU is
signal B_int : integer;
signal A_int: integer;
signal zero_int: integer;
signal MD_temp : signed (63 downto 0); -- temp signal for multiplication and division
signal hi, lo: signed (31 downto 0);
signal internal_R: integer;

begin    

zero_int <= 0;
	
process(op,a,b,rst)
	
begin
  
  if rst = '1' then
      
      R <= "00000000000000000000000000000000";
      zero <= '1';
  else
		case Op is
			when "100000" => 			-- ADD, ADD, 
				R  <= A+B;
			
	    when "100010" => 			-- SUB
				R <= A-B;
				internal_R <=to_integer(A-B);
				
			when "011000" => 			-- MULT
				MD_temp <= A*B;
--			  lo <= MD_temp(31 downto 0);
--				hi <= MD_temp(63 downto 32);
				
			when "011010" =>			-- DIV
				lo <= A / B;
				hi <= A mod B;
				
			when "101010" =>  			-- SLT
				if (A<B) then
					R <= "00000000000000000000000000000001";
				else
					R <= "00000000000000000000000000000000";  
				end if;
				
			when "100100" => 			-- AND
				R <= A and B;
			
			when "100101" =>			-- OR
				R <= A or B;
			
			when "100111" =>			-- NOR
		R <= A nor B;
	
	when "100110" =>			-- XOR
		R <= A xor B;
			
			when "010000" => 			-- MFHI
				R <= MD_temp(63 downto 32);
			
			when "010010" => 			-- MFLO
				R <= MD_temp(31 downto 0);
			
			when "000000" => 			-- SLL
				
				B_int <= to_integer(B);
				R <= A sll B_int;
				
			when "000010" =>			-- SRL
				
				B_int <= to_integer(B);
				R <= A srl B_int;
			
			when "000011" =>  			-- SRA
		B_int <= to_integer(B);
				R <= A +Shift_right(A, B_int);
		
	when "111111" => 			-- LUI
			
				R <= resize(B(31 downto 16),32);
				
			when "001000" => 			-- JR
			
				R <= A;
			
			when others => 
				NULL;
			
		end case;
		
	--with op select R <=
--   	  A+B when "100000",
--   	  A-B when "100010",
--   	  ALessB when "101010",
--     	A and B when "100100",
--     	A or B when "100101",
--     	A nor B when "100111",
--     	A xor B when "100110",
--     	MD_temp(63 downto 32)	when "010000",
--     	MD_temp(31 downto 0) when "010010",
--     	A sll B_int when "000000",
--   	  A srl B_int when "000010",
--   	  A +Shift_right(A, B_int) when "000011",
--		  resize(B(31 downto 16),32) when "111111",
--			A when "001000",
--    	 "00000000000000000000000000000000" when others;
--    	 
--    with op select MD_temp <= 
--      A*B when "011000",
--      hold when others;
      
	
	if  (internal_R = zero_int) then
		zero <= '1';
	end if;
	
	end if;
		
end process;
end architecture RTL;
